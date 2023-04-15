import 'package:artgen/components/adMob_view.dart';
import 'package:artgen/components/horisontal_image_listview.dart';
import 'package:artgen/models/websockets.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:artgen/views/main_detail_views/image_details_view.dart';
import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../../constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:convert';

class MyGalleryCenterView extends StatefulWidget {
  MyGalleryCenterView(
      {Key? key,
      this.setViewMode,
      // this.selectedImages,
      // this.selectedImageUrls,
      // this.updateSelectedImages,
      this.showDetailView})
      : super(key: key) {
    // _initAd();
  }
  final Function? setViewMode;
  // final Function? updateSelectedImages;
  final Function? showDetailView;
  // final selectedImages;
  // final selectedImageUrls;
  // final List<String> imageUrls = [];
  // final List<dynamic> images = [];

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
  // Set<dynamic>? _selectedImages;
  // Set<String>? _selectedImageUrls;
  // List<String> imageUrls = [];
  // List<dynamic> images = [];
  final pink = const Color(0xFFFACCCC);
  final grey = const Color(0xFFF2F2F7);
  bool loading = false;
  int retries = 0;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String pubTopic = "search";
  String pubTopicFeatured = "featured";
  String searchString = '';

  String _avatarImage =
      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg';

  late MyWebsockets galleryWs;
  List<String> imageUrls = [];
  List<dynamic> images = [];

  @override
  void initState() {
    super.initState();
    // _selectedImages = widget.selectedImages;
    // _selectedImageUrls = widget.selectedImageUrls;
    // imageUrls = widget.imageUrls;
    // images = widget.images;
    user.loggedInUserFuture.then((_) {
      setupWebsockets();
      user.haveCheckpointFiles.then((_) {
        print("Goind to get Featured Images...");
        getGalleryImageUrls();
      });
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

  void showSearchResults(String message) {
    bool isNsfw = false;
    loading = false;
    var jsonMap = jsonDecode(message);

    // print(jsonMap['_source']['details']['images']['images'][0]);
    // print(jsonMap);
    String url = jsonMap['_source']['details']['images']['images'][0];

    if (jsonMap['_source']['nsfw_probs'] != null) {
      double nsfwProb = jsonMap['_source']['nsfw_probs'][0];
      isNsfw = nsfwProb > user.nsfwFilterSliderValue;
    }

    if (!imageUrls.contains(url) && !isNsfw) {
      imageUrls.add(url);
      images.add(jsonMap);
    }

    setState(() {
      imageUrls = imageUrls;
      images = images;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
              title: Text('ArtGen'),
              backgroundColor: kButtonLightPurple,
            )
          : null,
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
              SizedBox(
                  height:
                      Responsive.isMobile(context) ? kDefaultHeight * 2 : 0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    Expanded(
                      flex: 18,
                      child: Text(''),
                    ),
                    if (Responsive.isDesktop(context))
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          width: 45,
                          height: 45,
                          child: CircleAvatar(
                              backgroundImage: NetworkImage(_avatarImage)),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              Expanded(
                child: loading
                    ? Column(children: [
                        SizedBox(height: kDefaultPadding),
                        SizedBox(
                            width: 200,
                            height: 200,
                            child: SpinKitThreeBounce(color: Colors.pink)),
                        Text('')
                      ])
                    : GridView.builder(
                        shrinkWrap: true,
                        itemCount: imageUrls.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: imageUrls.length < 3 ? 1 : 3,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 0,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ImageDetailsModal(
                                    selectedImageUrl: imageUrls[index],
                                  );
                                },
                              );
                              setState(() {});
                            },
                            child: FadeInImage(
                              placeholder:
                                  AssetImage('assets/images/tmp_image.png'),
                              image: NetworkImage(imageUrls[index]),
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(height: kDefaultPadding),
              // if (Responsive.isMobile(context))
              //   Container(
              //     height: 50.0,
              //     width: 350,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: kPurple,
              //     ),
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         // shadowColor: Colors.transparent,
              //         backgroundColor: Colors.transparent,
              //         shadowColor: Colors.transparent,
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(10)),
              //       ),
              //       child: Text(
              //         'Create',
              //         style: TextStyle(fontSize: 18),
              //       ),
              //       onPressed: () {
              //         widget.showDetailView!();
              //       },
              //     ),
              //   ),
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
  List<String> imageUrls = [];
  List<dynamic> images = [];

  @override
  void initState() {
    super.initState();
    _selectedImages = widget.selectedImages;
    _selectedImageUrls = widget.selectedImageUrls;
    images = widget.images;
    imageUrls = widget.imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    images = widget.images;
    imageUrls = widget.imageUrls;
    return MasonryGridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      shrinkWrap: true,
      itemCount: imageUrls.length,
      itemBuilder: (BuildContext context, int index) {
        final imageUrl = imageUrls[index];
        final imageFull = images[index];
        final isSelected = _selectedImageUrls!.contains(imageUrl);
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
                print("Selected image Details: ");
                print(imageFull);
                print(imageUrl);
                if (isSelected) {
                  _selectedImageUrls!.remove(imageUrl);
                  _selectedImages!.remove(imageFull);
                } else {
                  if (_selectedImageUrls!.length < 5) {
                    // Limit the number of selected images to 5
                    _selectedImageUrls!.add(imageUrl);
                    _selectedImages!.add(imageFull);
                  }
                }
                widget.updateSelectedImages!(
                    _selectedImages, _selectedImageUrls);
              });
            },
            child: FadeInImage(
              placeholder: AssetImage('assets/images/tmp_image.png'),
              image: NetworkImage(imageUrl),
            ),
          ),
        );
      },
    );
  }
}
