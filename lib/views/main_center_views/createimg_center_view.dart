import 'package:artgen/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<List<String>> getImageUrls() async {
  final uri = Uri.https('lexica.art', '/api/v1/search', {'q': 'apples'});
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final urls =
        jsonData['images'].map<String>((url) => url.toString()).toList();
    // print(urls[0]);
    return urls;
  } else {
    throw Exception('Failed to load images');
  }
}

class ImgGridView extends StatefulWidget {
  ImgGridView(
      {Key key,
      this.setViewMode,
      this.selectedImages,
      this.selectedImageUrls,
      this.updateSelectedImages,
      this.showDetailView})
      : super(key: key);
  final Function setViewMode;
  final Function updateSelectedImages;
  final Function showDetailView;
  final selectedImages;
  final selectedImageUrls;
  @override
  State<ImgGridView> createState() => _ImgGridViewState();
}

class _ImgGridViewState extends State<ImgGridView> {
  Set<dynamic> _selectedImages;
  Set<String> _selectedImageUrls;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _selectedImages = widget.selectedImages;
    _selectedImageUrls = widget.selectedImageUrls;
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
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                      ),
                    if (!Responsive.isDesktop(context)) SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          getImageUrls();
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
              Expanded(
                child: ImageGridView(
                    selectedImages: _selectedImages,
                    selectedImageUrls: _selectedImageUrls,
                    updateSelectedImages: widget.updateSelectedImages,
                    showDetailView: widget.showDetailView),
              ),
              SizedBox(height: kDefaultPadding),
              Container(
                height: 80,
                child: RoundedButton(
                  text: "Create",
                  press: () {
                    widget.showDetailView();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Popup title"),
                          content: Text(
                              "This is the message displayed in the popup"),
                          actions: <Widget>[
                            Container(
                              height: 80,
                              width: 500,
                              child: RoundedButton(
                                text: "OK",
                                press: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        );
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
}

class ImageGridView extends StatefulWidget {
  final Set<dynamic> selectedImages;
  final Set<String> selectedImageUrls;
  final Function updateSelectedImages;
  final Function showDetailView;

  const ImageGridView(
      {Key key,
      this.updateSelectedImages,
      this.selectedImageUrls,
      this.selectedImages,
      this.showDetailView})
      : super(key: key);

  @override
  _ImageGridViewState createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  Set<String> _selectedImageUrls;
  Set<dynamic> _selectedImages;
  List<String> _imageUrls = [];
  List<dynamic> _images = [];

  @override
  void initState() {
    super.initState();
    getImageUrls();
    _selectedImages = widget.selectedImages;
    _selectedImageUrls = widget.selectedImageUrls;
  }

  Future<List<String>> getImageUrls() async {
    final uri = Uri.https('lexica.art', '/api/v1/search', {'q': 'apples'});
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _imageUrls.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        // childAspectRatio: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        final imageUrl = _imageUrls[index];
        final imageFull = _images[index];
        final isSelected = _selectedImageUrls.contains(imageUrl);

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
                  _selectedImageUrls.remove(imageUrl);
                  _selectedImages.remove(imageFull);
                } else {
                  _selectedImageUrls.add(imageUrl);
                  _selectedImages.add(imageFull);
                  // print(_selectedImages);
                }
                widget.updateSelectedImages(
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
