import 'package:artgen/components/adMob_view.dart';
import 'package:artgen/components/horisontal_image_listview.dart';
import 'package:artgen/models/websockets.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:artgen/views/main_detail_views/image_details_view.dart';
import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:mqtt5_client/mqtt5_browser_client.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../../constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class MyGalleryCenterView extends StatefulWidget {
  MyGalleryCenterView(
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
  final List<String> imageUrls = [];
  final List<dynamic> images = [];

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
  State<MyGalleryCenterView> createState() => _MyGalleryCenterViewState();
}

class _MyGalleryCenterViewState extends State<MyGalleryCenterView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Set<dynamic>? _selectedImages;
  Set<String>? _selectedImageUrls;
  List<String> _imageUrls = [];
  List<dynamic> _images = [];
  final pink = const Color(0xFFFACCCC);
  final grey = const Color(0xFFF2F2F7);
  bool loading = false;
  bool getFeatured = true;
  int retries = 0;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  // MQTTClientManager mqttClientManager = MQTTClientManager();
  String pubTopic = "search";
  String pubTopicFeatured = "gallery";
  // String subTopic = '';
  String searchString = '';

  String _avatarImage =
      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg';

  late MyWebsockets galleryWs;
  Set<String> imageUrls = Set();
  List<dynamic> images = [];

  @override
  void initState() {
    super.initState();
    // setupWSClient();
    _selectedImages = widget.selectedImages;
    _selectedImageUrls = widget.selectedImageUrls;
    _imageUrls = widget.imageUrls;
    _images = widget.images;
    user.loggedInUserFuture.then((_) {
      print("User logged in, setting up gallery websocket");
      setupWebsockets();
      getGalleryImageUrls();
    });
  }

  @override
  void dispose() {
    galleryWs.close();
    super.dispose();
  }

  void setupWebsockets() {
    print("setupWebsockets()");

    galleryWs = MyWebsockets(
      onMessageReceived: (message) {
        setState(() {
          showSearchResults(message);
        });
      },
      topic: user.gallerySubTopic,
    );
  }

  getGalleryImageUrls() {
    getFeatured = true;

    var query = {
      'user': user.user!.uid,
      'pos': 0,
      'size': 100,
      'uid': user.user?.uid,
      'topic': 'gallery-search'
    };
    print("JSON Encoded query:");
    print(jsonEncode(query));
    galleryWs.sendMessage(query);

    setState(() {
      user.modelList = user.modelList;
      loading = true;
    });
  }

  centerViewUpdateSelectedImages(_selectedImages, _selectedImageUrls) {
    setState(() {
      // _selectedImages = widget.selectedImages;
      // _selectedImageUrls = widget.selectedImageUrls;
      // widget.updateSelectedImages!(_selectedImages, _selectedImageUrls);
    });
  }

  void showSearchResults(String message) {
    loading = false;
    var jsonMap = jsonDecode(message);
    print(jsonMap['_source']['details']['images']['images'][0]);
    String url = jsonMap['_source']['details']['images']['images'][0];
    imageUrls.add(url);
    images.add(jsonMap);
    setState(() {
      _imageUrls = imageUrls.toList();
      _images = images;
      loading = false;
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
                    SizedBox(width: 5),
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 35,
                        alignment: Alignment.center,
                        child: Text(
                          "My Gallery",
                          style: TextStyle(
                            fontFamily:
                                'custom font', // remove this if don't have custom font
                            fontSize: 20.0, // text size
                            color: Color.fromARGB(255, 144, 142, 142),
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(left: 40),
                    //   width: 40,
                    //   height: 40,
                    //   child: CircleAvatar(
                    //     backgroundImage: NetworkImage(_avatarImage),
                    //   ),
                    // ),

                    Container(
                      margin: EdgeInsets.only(left: 20),
                      width: 45,
                      height: 45,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(_avatarImage),
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              Responsive.isMobile(context)
                  ? Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "",
                        style: TextStyle(
                          fontFamily:
                              'custom font', // remove this if don't have custom font
                          fontSize: 15.0, // text size
                          color: Color.fromARGB(255, 144, 142, 142),
                          // text color
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 0,
                    ),
              Responsive.isMobile(context)
                  ? Container(
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
                    )
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(
                  height:
                      Responsive.isMobile(context) ? kDefaultPadding / 2 : 0),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "",
                  style: TextStyle(
                    fontFamily:
                        'custom font', // remove this if don't have custom font
                    fontSize: 15.0, // text size
                    color: Color.fromARGB(255, 144, 142, 142), // text color
                  ),
                ),
              ),
              SizedBox(
                  height:
                      Responsive.isMobile(context) ? kDefaultPadding / 2 : 0),
              Expanded(
                child: loading
                    ? Container(
                        // ? Column(children: [
                        // SizedBox(
                        // width: 20,
                        // height: 20,
                        // child: CircularProgressIndicator()),
                        // Text(''),
                        child: Image.network("assets/images/tmp_image.png"))
                    // ])
                    : ImageGridView(
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
            ],
          ),
        ),
      ),
    );
  }

  // void onAdLoaded(InterstitialAd ad) {}
}

class ImageGridView extends StatefulWidget {
  final Set<dynamic>? selectedImages;
  final Set<String>? selectedImageUrls;
  final Function? updateSelectedImages;
  final Function? showDetailView;
  final List<String> imageUrls;
  final List<dynamic> images;

  ImageGridView(
      {Key? key,
      this.updateSelectedImages,
      this.selectedImageUrls,
      this.selectedImages,
      this.showDetailView,
      required this.images,
      required this.imageUrls})
      : super(key: key);

  @override
  _ImageGridViewState createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  Set<String>? _selectedImageUrls;
  Set<dynamic>? _selectedImages;
  List<String> _imageUrls = [];
  List<dynamic> _images = [];

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
      crossAxisCount: Responsive.isMobile(context) ? 3 : 8,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      shrinkWrap: true,
      itemCount: _imageUrls.length,
      itemBuilder: (BuildContext context, int index) {
        final imageUrl = _imageUrls[index];
        // final imageFull = _images[index];
        // final isSelected = _selectedImageUrls!.contains(imageUrl);
        return Container(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ImageDetailsModal(
                    selectedImageUrl: imageUrl,
                  );
                },
              );
              setState(() {});
            },
            child: FadeInImage(
              placeholder: AssetImage("assets/images/tmp_image.png"),
              image: NetworkImage(imageUrl),
            ),
          ),
        );
      },
    );
  }
}