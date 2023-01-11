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
    print(urls[0]);
    return urls;
  } else {
    throw Exception('Failed to load images');
  }
}

class ImgGridView extends StatefulWidget {
  const ImgGridView({
    Key key,
    this.setViewMode,
  }) : super(key: key);
  final Function setViewMode;
  @override
  State<ImgGridView> createState() => _ImgGridViewState();
}

class _ImgGridViewState extends State<ImgGridView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
                child: ImageGridView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageGridView extends StatefulWidget {
  @override
  _ImageGridViewState createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  final _selectedImages = Set<String>();
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    getImageUrls();
  }

  Future<List<String>> getImageUrls() async {
    final uri = Uri.https('lexica.art', '/api/v1/search', {'q': 'apples'});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      // final images = jsonData['images'].map<String>((url) => url.toString()).toList();
      final urls = jsonData['images']
          .map<String>((image) => image['src'].toString())
          .toList();

      setState(() {
        _imageUrls = urls;
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
        childAspectRatio: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        final imageUrl = _imageUrls[index];
        final isSelected = _selectedImages.contains(imageUrl);

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
                  _selectedImages.remove(imageUrl);
                } else {
                  _selectedImages.add(imageUrl);
                }
              });
            },
            child: Image.network(imageUrl),
          ),
        );
      },
    );
  }
}
