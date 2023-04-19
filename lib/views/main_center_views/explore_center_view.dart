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
import 'package:universal_platform/universal_platform.dart';
import '../../../constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:convert';

class ExploreCenterView extends StatefulWidget {
  ExploreCenterView(
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
  final Function? showDetailView;

  @override
  State<ExploreCenterView> createState() => _ExploreCenterViewState();
}

class _ExploreCenterViewState extends State<ExploreCenterView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final pink = const Color(0xFFFACCCC);
  final grey = const Color(0xFFF2F2F7);
  bool loading = false;
  int retries = 0;
  bool getFeatured = true;
  BannerAd? bannerAd;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String pubTopic = "search";
  String pubTopicFeatured = "featured";
  String searchString = '';

  String _avatarImage =
      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg';

  late MyWebsockets searchWs;
  late MyWebsockets featuredWs;
  List<String> imageUrls = [];
  List<dynamic> images = [];

  @override
  void initState() {
    super.initState();
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
      bannerAd = AdManager.createBannerAd()..load();
    user.loggedInUserFuture.then((_) {
      if (user.user?.photoURL != null) {
        setState(() {
          _avatarImage = user.user!.photoURL!;
        });
      }
      setupWebsockets();
      user.haveCheckpointFiles.then((_) {
        print("Goind to get Featured Images...");
        getFeaturedImageUrls();
      });
    });
  }

  @override
  void dispose() {
    searchWs.close();
    featuredWs.close();
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
      bannerAd?.dispose();
    super.dispose();
  }

  Widget _buildBannerAdWidget() {
    return AdWidget(ad: bannerAd!);
  }

  void setupWebsockets() {
    print("setupWebsockets()");
    searchWs = MyWebsockets(
      onMessageReceived: (message) {
        setState(() {
          showSearchResults(message);
        });
      },
      topic: user.searchSubTopic,
    );

    featuredWs = MyWebsockets(
      onMessageReceived: (message) {
        setState(() {
          showSearchResults(message);
        });
      },
      topic: user.featuredSubTopic,
    );
  }

  getSearchImageUrls([String q = "featured"]) async {
    getFeatured = false;
    imageUrls = [];
    images = [];

    var query = {
      'keywords': q,
      'pos': 0,
      'size': 100,
      'uid': user.user?.uid,
      'topic': 'keyword-search'
    };

    print("JSON Encoded query:");
    print(jsonEncode(query));
    setupWebsockets();
    featuredWs.sendMessage(query);

    setState(() {
      loading = true;
    });
  }

  getFeaturedImageUrls() async {
    getFeatured = true;
    imageUrls = [];
    images = [];

    var query = {
      'model': user.pubTopic,
      'pos': 0,
      'size': 100,
      'uid': user.user?.uid,
      'topic': 'featured-search'
    };
    print("JSON Encoded query:");
    print(jsonEncode(query));
    setupWebsockets();
    searchWs.sendMessage(query);

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
              title: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      child: Text(
                        "Explore",
                        style: TextStyle(
                          fontFamily:
                              'custom font', // remove this if don't have custom font
                          fontSize: 20.0, // text size
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  // if (Responsive.isDesktop(context))
                  Container(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      width: 45,
                      height: 45,
                      child: CircleAvatar(
                          backgroundImage: NetworkImage(_avatarImage)),
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
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
                      flex: 9,
                      child: TextField(
                        textAlign: TextAlign.center,
                        onSubmitted: (value) {
                          setState(() {
                            searchString = value;
                            getSearchImageUrls(value);
                          });
                        },
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: kTextFontSize,
                            color: kTextColorLightGrey,
                          ),
                          hintText: "Search",
                          fillColor: kTextFieldBackgroundColor,
                          filled: true,
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(
                                right: Responsive.isDesktop(context)
                                    ? kDefaultWidth
                                    : 0),
                            child: Icon(
                              Icons.search,
                              color: kButtonLightPurple,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(kDefaultBorderRadius)),
                            borderSide: BorderSide(
                                color: kTextFieldBackgroundColor, width: 2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        width: Responsive.isDesktop(context)
                            ? kDefaultWidth * 2
                            : kDefaultWidth),
                    Expanded(
                      flex: 9,
                      child: Container(
                        height: 40,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: kTextFieldBackgroundColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(kDefaultBorderRadius)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: user.selectedModel,
                              borderRadius: BorderRadius.circular(20),
                              itemHeight: 50,
                              items: user.modelList
                                  .map<DropdownMenuItem<String>>(
                                      (String dropDownText) {
                                return DropdownMenuItem<String>(
                                    value: dropDownText,
                                    child: Row(
                                      children: [
                                        SizedBox(width: kDefaultWidth),
                                        Expanded(
                                          child: Text(
                                            dropDownText,
                                            maxLines: 1,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontSize: kTextFontSize,
                                              color: kTextColorLightGrey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  user.selectedModel = newValue!;
                                  user.pubTopic = user.selectedModel;
                                  getFeaturedImageUrls();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
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
                            child:
                                SpinKitThreeBounce(color: kButtonLightPurple)),
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
                                    selectedImageMeta: images[index],
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
              if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
                Container(
                  width: bannerAd!.size.width.toDouble(),
                  height: bannerAd!.size.height.toDouble(),
                  child: _buildBannerAdWidget(),
                )
              else
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
