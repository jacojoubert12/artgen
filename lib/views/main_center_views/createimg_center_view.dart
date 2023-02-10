import 'package:artgen/components/adMob_view.dart';
import 'package:artgen/components/horisontal_image_listview.dart';
import 'package:artgen/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  List<String>? _imageUrls;
  List<dynamic>? _images;

  @override
  void initState() {
    super.initState();
    _selectedImages = widget.selectedImages;
    _selectedImageUrls = widget.selectedImageUrls;
    _imageUrls = widget.imageUrls;
    _images = widget.images;
    getImageUrls();
  }

  Future<List<String>?> getImageUrls([String q = "random"]) async {
    final uri = Uri.https('lexica.art', '/api/v1/search', {'q': q});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      // print(jsonData);
      final images = jsonData['images'].map<dynamic>((url) => url).toList();
      final urls = jsonData['images']
          .map<String>((image) => image['src'].toString())
          .toList();

      setState(() {
        _imageUrls = urls;
        _images = images;
      });

      return urls;
    } else {
      throw Exception('Failed to load images');
    }
  }

  centerViewUpdateSelectedImages(_selectedImages, _selectedImageUrls) {
    setState(() {
      _selectedImages = widget.selectedImages;
      _selectedImageUrls = widget.selectedImageUrls;
      widget.updateSelectedImages!(_selectedImages, _selectedImageUrls);
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
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) {
                          setState(() {
                            getImageUrls(value);
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search",
                          fillColor: kBgLightColor,
                          filled: true,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(
                                kDefaultPadding * 0.75), //15
                            child: WebsafeSvg.asset(
                              "assets/Icons/Search.svg",
                              width: 24,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              if (Responsive.isMobile(context))
                ImageListView(
                  updateSelectedImages: widget.updateSelectedImages,
                  selectedImages: _selectedImages,
                  selectedImageUrls: _selectedImageUrls,
                ),
              SizedBox(height: kDefaultPadding),
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
                  child: Text('Adds'),
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
    return GridView.builder(
      shrinkWrap: true,
      itemCount: _imageUrls!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        final imageUrl = _imageUrls![index];
        final imageFull = _images![index];
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
