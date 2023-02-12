import 'package:artgen/components/adMob_view.dart';
import 'package:artgen/components/horisontal_image_listview.dart';
import 'package:artgen/components/rounded_button.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'dart:math';

//TODOConsider moving these to MyUser of similar to use everywhere in app
import 'package:artgen/components/mqtt_client_manager.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:firebase_core/firebase_core.dart' as firebase_core;

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:convert';
import 'package:http/http.dart' as http;

class ImgGridView extends StatefulWidget {
  ImgGridView(
      {Key? key,
      this.setViewMode,
      this.selectedImages,
      this.selectedImageUrls,
      this.updateSelectedImages,
      this.showDetailView})
      : super(key: key) {
    // _initAd();
  }
  final Function? setViewMode;
  final Function? updateSelectedImages;
  final Function? showDetailView;
  final selectedImages;
  final selectedImageUrls;
  List<String> imageUrls = [];
  List<dynamic> images = [];

  // late InterstitialAd _interstitialAd;
  // bool _isAdLoaded = false;

  // void _initAd() {
  //   InterstitialAd.load(
  //     adUnitId: '<ad unit id>',
  //     request: AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //         onAdLoaded: onAdLoaded,
  //         onAdFailedToLoad: (error) {
  //           print('InterstitialAd failed to load: $error');
  //         }),
  //   );
  // }

  // void onAdLoaded(InterstitialAd ad) {
  //   _interstitialAd = ad;
  //   _isAdLoaded = true;
  // }

  @override
  State<ImgGridView> createState() => _ImgGridViewState();
}

class _ImgGridViewState extends State<ImgGridView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Set<dynamic>? _selectedImages;
  Set<String>? _selectedImageUrls;
  List<String> _imageUrls = [];
  List<dynamic> _images = [];
  final pink = const Color(0xFFFACCCC);
  final grey = const Color(0xFFF2F2F7);
  bool loading = false;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  MQTTClientManager mqttClientManager = MQTTClientManager();
  String pubTopic = "search";
  String subTopic = "search_response/" + user.user!.uid;

  @override
  void initState() {
    super.initState();
    setupMqttClient();
    setupUpdatesListener();
    _selectedImages = widget.selectedImages;
    _selectedImageUrls = widget.selectedImageUrls;
    _imageUrls = widget.imageUrls;
    _images = widget.images;
    getImageUrls();
  }

  @override
  void dispose() {
    mqttClientManager.disconnect();
    super.dispose();
  }

  getImageUrls([String q = "random"]) async {
    var query = {'keywords': q, 'response_topic': subTopic};
    mqttClientManager.publishMessage(pubTopic, jsonEncode(query));
    print("JSON Encoded query:");
    print(jsonEncode(query));

    setState(() {
      loading = true;
    });
  }

  centerViewUpdateSelectedImages(_selectedImages, _selectedImageUrls) {
    setState(() {
      _selectedImages = widget.selectedImages;
      _selectedImageUrls = widget.selectedImageUrls;
      widget.updateSelectedImages!(_selectedImages, _selectedImageUrls);
    });
  }

  Future<void> setupMqttClient() async {
    await mqttClientManager.connect();
    mqttClientManager.subscribe(subTopic);
  }

  void setupUpdatesListener() {
    mqttClientManager
        .getMessagesStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('MQTTClient::Message received on topic: <${c[0].topic}> is $pt\n');
      //   generatedImgUrls.clear();
      print("response");
      print(jsonDecode(pt));
      print("after");
      final List<String> imageUrls = [];
      final List<dynamic> images = [];
      for (var img in jsonDecode(pt)) {
        print(img);
        print('\n');
        print(img['_source']['details']['images'][0]);
        //Maybe add everything later - issue is if batch_size was 100 you dont want all to show?
        int len = img['_source']['details']['images'].length;
        var imgCount = min(len, 5);
        for (var i = 0; i < imgCount; i++) {
          var rawUrl = img['_source']['details']['images'][i];
          rawUrl = rawUrl.toString();
          String filename = rawUrl.substring(rawUrl.length - 40);
          String url = await storage.ref('images/$filename').getDownloadURL();
          imageUrls.add(url);
        }
        images.add(img);
      }
      setState(() {
        _imageUrls = imageUrls;
        _images = images;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(setViewMode: widget.setViewMode),
      ),
      body: Container(
        padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        color: kBgDarkColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              // This is our Seearch bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    // Once user click the menu icon the menu shows like drawer
                    // Also we want to hide this menu icon on desktop
                    if (!Responsive.isDesktop(context))
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: kButtonLightPurple,
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                      ),
                    if (!Responsive.isDesktop(context)) SizedBox(width: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 300,
                      height: 35,
                      child: TextField(
                        textAlign: TextAlign.center,
                        onSubmitted: (value) {
                          setState(() {
                            getImageUrls(value);
                          });
                        },
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 144, 142, 142),
                          ),
                          hintText: "Search for specific topics",
                          fillColor: kTextFieldBackgroundColor,
                          filled: true,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.search,
                              color: kButtonLightPurple,
                            ),
                            // child: WebsafeSvg.asset(
                            //   "assets/Icons/Search.svg",
                            //   width: 15,
                            // ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: kTextFieldBackgroundColor, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              if (Responsive.isMobile(context))
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Selected images",
                    style: TextStyle(
                      fontFamily:
                          'custom font', // remove this if don't have custom font
                      fontSize: 15.0, // text size
                      color: Color.fromARGB(255, 144, 142, 142),
                      // text color
                    ),
                  ),
                ),

              SizedBox(height: kDefaultPadding / 2),
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 77, 75, 75),
                      width: 2.0,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ImageListView(
                  updateSelectedImages: widget.updateSelectedImages,
                  selectedImages: _selectedImages,
                  selectedImageUrls: _selectedImageUrls,
                ),
              ),

              SizedBox(height: kDefaultPadding / 2),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Select up to 5 Images",
                  style: TextStyle(
                    fontFamily:
                        'custom font', // remove this if don't have custom font
                    fontSize: 15.0, // text size
                    color: Color.fromARGB(255, 144, 142, 142), // text color
                  ),
                ),
              ),

              SizedBox(height: kDefaultPadding / 2),
              //Image Grid View

              // Expanded(
              //   child: MasonryGridView.count(
              //     crossAxisCount: 4,
              //     mainAxisSpacing: 4,
              //     crossAxisSpacing: 4,
              //     itemBuilder: (context, index) {

              //       return Tile(
              //         index: index,
              //         extent: (index % 5 + 1) * 100,
              //       );
              //     },
              //   ),
              // ),

              Expanded(
                child: ImageGridView(
                    selectedImages: _selectedImages,
                    selectedImageUrls: _selectedImageUrls,
                    updateSelectedImages:
                        centerViewUpdateSelectedImages, //widget.updateSelectedImages,
                    showDetailView: widget.showDetailView,
                    imageUrls: _imageUrls,
                    images: _images),
              ),
              SizedBox(height: kDefaultPadding),
              if (Responsive.isMobile(context))
                Container(
                  height: 35.0,
                  width: 350,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 61, 2, 50),
                        Color.fromARGB(255, 10, 6, 20)
                      ])),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Create'),
                    onPressed: () {
                      widget.showDetailView!();
                    },
                  ),
                ),
              SizedBox(height: kDefaultPadding),
              Container(
                height: 35.0,
                width: 350,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 61, 2, 50),
                      Color.fromARGB(255, 10, 6, 20)
                    ])),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Addds'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AdMob();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onAdLoaded(InterstitialAd ad) {}
}

class ImageGridView extends StatefulWidget {
  final Set<dynamic>? selectedImages;
  final Set<String>? selectedImageUrls;
  final Function? updateSelectedImages;
  final Function? showDetailView;
  final List<String>? imageUrls;
  final List<dynamic>? images;

  const ImageGridView(
      {Key? key,
      this.updateSelectedImages,
      this.selectedImageUrls,
      this.selectedImages,
      this.showDetailView,
      this.images,
      this.imageUrls})
      : super(key: key);

  @override
  _ImageGridViewState createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  Set<String>? _selectedImageUrls;
  Set<dynamic>? _selectedImages;
  List<String>? _imageUrls; // = [];
  List<dynamic>? _images; // = [];

  @override
  void initState() {
    super.initState();
    _selectedImages = widget.selectedImages;
    _selectedImageUrls = widget.selectedImageUrls;
    _images = widget.images;
    _imageUrls = widget.imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    _images = widget.images;
    _imageUrls = widget.imageUrls;
    return MasonryGridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      // return GridView.builder(
      shrinkWrap: true,
      itemCount: _imageUrls!.length,
      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //   crossAxisCount: 3,
      //   childAspectRatio: 1,
      // ),
      itemBuilder: (BuildContext context, int index) {
        final imageUrl = _imageUrls![index];
        final imageFull = _images![index];
        final isSelected = _selectedImageUrls!.contains(imageUrl);

        // return Tile(
        //               index: index,
        //               extent: (index % 5 + 1) * 100,
        //             );

        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2.0,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedImageUrls!.remove(imageUrl);
                  _selectedImages!.remove(imageFull);
                } else {
                  _selectedImageUrls!.add(imageUrl);
                  _selectedImages!.add(imageFull);
                  // print(_selectedImages);
                }
                widget.updateSelectedImages!(
                    _selectedImages, _selectedImageUrls);
              });
            },
            child: Image.network(imageUrl),
          ),
        );
      },
    );
  }
}
