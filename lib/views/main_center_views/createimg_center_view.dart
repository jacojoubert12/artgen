import 'package:universal_platform/universal_platform.dart';

import 'package:artgen/components/adMob_view.dart';
import 'package:artgen/components/horisontal_image_listview.dart';
import 'package:artgen/models/websockets.dart';
import 'package:artgen/views/main/main_view.dart';
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
  final List<String> imageUrls = [];
  final List<dynamic> images = [];

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
  int retries = 0;
  bool getFeatured = true;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String pubTopic = "search";
  String pubTopicFeatured = "featured";
  String searchString = '';

  String _avatarImage = 'https://ws.artgen.fun/images/icon.png';

  late MyWebsockets searchWs;
  late MyWebsockets featuredWs;
  List<String> imageUrls = [];
  List<dynamic> images = [];

  ScrollController _scrollController = ScrollController();
  int searchSize = 100;
  int scrollBottoms = 0;

  BannerAd? bannerAd;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
      bannerAd = AdManager.createBannerAd()..load();
    _selectedImages = widget.selectedImages;
    _selectedImageUrls = widget.selectedImageUrls;
    _imageUrls = widget.imageUrls;
    _images = widget.images;
    user.loggedInUserFuture.then((_) {
      setupWebsockets();
      user.haveCheckpointFiles.then((_) {
        print("Goind to get Featured Images...");
        getFeaturedImageUrls();
        if (user.user?.photoURL != null) {
          setState(() {
            _avatarImage = user.user!.photoURL!;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    searchWs.close();
    featuredWs.close();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      bannerAd?.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    double currentScrollPosition = _scrollController.position.pixels;

    // Calculate the distance to the bottom
    double distanceToBottom = maxScrollExtent - currentScrollPosition;

    // Define the threshold in pixels (e.g., the height of 5 grid items)
    double thresholdInPixels = 3000;

    if (distanceToBottom <= thresholdInPixels && _images.length > 20) {
      print("Goign to search more... ${scrollBottoms}");
      scrollBottoms += 1;
      if (getFeatured) {
        var query = {
          'model': user.pubTopic,
          'pos': searchSize * scrollBottoms,
          'size': searchSize,
          'uid': user.user?.uid,
          'topic': 'featured-search'
        };
        featuredWs.sendMessage(query);
      } else {
        List<String> words = searchString.split(' ');
        words.forEach((word) {
          var query = {
            'keywords': word,
            'pos': searchSize * scrollBottoms,
            'size': searchSize,
            'uid': user.user?.uid,
            'topic': 'keyword-search'
          };
          searchWs.sendMessage(query);
        });
      }
    }
  }

  Widget _buildBannerAdWidget() {
    return AdWidget(ad: bannerAd!);
  }

  void setupWebsockets() {
    print("setupWebsockets()");
    try {
      searchWs.close();
    } catch (e) {
      print('Error closing searchWs: $e');
    }
    try {
      featuredWs.close();
    } catch (e) {
      print('Error closing searchWs: $e');
    }

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
    scrollBottoms = 0;
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
    scrollBottoms = 0;
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

  centerViewUpdateSelectedImages(_selectedImages, _selectedImageUrls) {
    setState(() {
      _selectedImages = widget.selectedImages;
      _selectedImageUrls = widget.selectedImageUrls;
      widget.updateSelectedImages!(_selectedImages, _selectedImageUrls);
    });
  }

  void showSearchResults(String message) {
    bool isNsfw = false;
    bool hasPrompt = false;
    loading = false;
    var jsonMap = jsonDecode(message);

    // print(jsonMap['_source']['details']['images']['images'][0]);
    // print(jsonMap);
    String url = jsonMap['_source']['details']['images']['images'][0];
    // String url = jsonMap['_source']['details']['images']['thumbnails'][0];

    if (jsonMap['_source']['nsfw_probs'] != null) {
      double nsfwProb = jsonMap['_source']['nsfw_probs'][0];
      isNsfw = nsfwProb > user.nsfwFilterSliderValue;
    }

    if (jsonMap['_source']['details']['parameters'] != null) {
      hasPrompt =
          jsonMap['_source']['details']['parameters']['prompt'].length > 30;
    }

    if (!imageUrls.contains(url) && !isNsfw && hasPrompt) {
      imageUrls.add(url);
      images.add(jsonMap);
    }

    setState(() {
      _imageUrls = imageUrls;
      _images = images;
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
                      flex: 4,
                      child: TextField(
                        style: TextStyle(
                          color: kTextColorLightGrey,
                        ),
                        textAlign: TextAlign.center,
                        onSubmitted: (value) {
                          setState(() {
                            searchString = value;
                            List<String> words = searchString.split(' ');
                            words.forEach((word) => getSearchImageUrls(word));
                            // getSearchImageUrls(value);
                          });
                        },
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: kTextFontSize,
                            color: kTextColorLightGrey,
                          ),
                          hintText: "Search for inspiration",
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
                      flex: 4,
                      child: Container(
                        height: Responsive.isMobile(context) ? 50 : 40,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: kTextFieldBackgroundColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(kDefaultBorderRadius)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: kDropDownGrey,
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
              if (Responsive.isMobile(context))
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
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
                      SizedBox(height: kDefaultHeight / 2),
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
                      SizedBox(height: kDefaultHeight),
                    ],
                  ),
                ),
              // Container(
              //   alignment: Alignment.centerLeft,
              //   padding: const EdgeInsets.only(left: 20.0),
              //   child: Text(
              //     "Select up to 5 Images",
              //     style: TextStyle(
              //       fontFamily:
              //           'custom font', // remove this if don't have custom font
              //       fontSize: 15.0, // text size
              //       color: Color.fromARGB(255, 144, 142, 142), // text color
              //     ),
              //   ),
              // ),
              SizedBox(
                  height:
                      Responsive.isMobile(context) ? kDefaultHeight / 2 : 0),
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
                    : ImageGridView(
                        scrollController: _scrollController,
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
                  height: 50.0,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kButtonLightPurple,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Create',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      widget.showDetailView!();
                    },
                  ),
                ),

              SizedBox(
                height: (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
                    ? (kDefaultPadding / 2) : kDefaultPadding
              ),
              if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
                Container(
                  width: bannerAd!.size.width.toDouble(),
                  height: bannerAd!.size.height.toDouble(),
                  child: _buildBannerAdWidget(),
                )
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
  final ScrollController? scrollController;

  ImageGridView(
      {Key? key,
      this.updateSelectedImages,
      this.selectedImageUrls,
      this.selectedImages,
      this.showDetailView,
      this.scrollController,
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
      controller: widget.scrollController,
      crossAxisCount: 4,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      shrinkWrap: true,
      itemCount: _imageUrls.length,
      itemBuilder: (BuildContext context, int index) {
        final imageUrl = _imageUrls[index];
        final imageFull = _images[index];
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
