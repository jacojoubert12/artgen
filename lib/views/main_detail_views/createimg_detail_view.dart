import 'dart:convert';
import 'dart:developer' as developer;
import 'package:artgen/components/horisontal_image_listview.dart';
import 'package:artgen/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import 'components/header.dart';

class CreateImgDetailView extends StatefulWidget {
  CreateImgDetailView(
      {Key key,
      this.selectedImages,
      this.selectedImageUrls,
      this.updateSelectedImages})
      : super(key: key);
  final selectedImages;
  final selectedImageUrls;
  final Function updateSelectedImages;

  @override
  State<CreateImgDetailView> createState() => _CreateImgDetailViewState();
}

class _CreateImgDetailViewState extends State<CreateImgDetailView> {
  Set<dynamic> _selectedImages;
  Set<String> _selectedImageUrls;
  String prompt = "";
  String generatedImgUrl = "http://localhost:5000/output/" + "output.png";

  @override
  void initState() {
    super.initState();
    _selectedImages = widget.selectedImages;
    _selectedImageUrls = widget.selectedImageUrls;
  }

  concatPrompts() {
    prompt = "";
    for (var jsonString in _selectedImages) {
      if (jsonString != null) {
        var json = jsonEncode(jsonString['prompt']);
        prompt += jsonDecode(json) + " ";
      }
    }
    print(prompt);
  }

  generateImage() async {
    // final response = await http.get('http://localhost:5000?name=John');
    String img;
    final uri = Uri.http('localhost:5000', '/'); // {"prompt": prompt});

    final response = await http.post(
      uri,
      body: jsonEncode({'prompt': prompt}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      img = data['image'];
      print(img);
      setState(() {
        generatedImgUrl = "http://localhost:5000/" + img;
      });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Header(),
              Divider(thickness: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        maxRadius: 24,
                        backgroundColor: Colors.transparent,
                        // backgroundImage: AssetImage(emails[1].image),
                      ),
                      SizedBox(width: kDefaultPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                ),
                                SizedBox(width: kDefaultPadding / 2),
                                Text(
                                  DateTime.now().toString(),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            SizedBox(height: kDefaultPadding),
                            LayoutBuilder(
                              builder: (context, constraints) => SizedBox(
                                width: constraints.maxWidth > 850
                                    ? 800
                                    : constraints.maxWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   "Todo: Replace this text - Replacing....",
                                    //   style: TextStyle(
                                    //     height: 1.5,
                                    //     color: Color(0xFF4D5875),
                                    //     fontWeight: FontWeight.w300,
                                    //   ),
                                    // ),
                                    // SizedBox(height: kDefaultPadding),
                                    ImageListView(
                                      updateSelectedImages:
                                          widget.updateSelectedImages,
                                      selectedImages: _selectedImages,
                                      selectedImageUrls: _selectedImageUrls,
                                    ),
                                    SizedBox(height: kDefaultPadding),
                                    Container(
                                      child: Image.network(generatedImgUrl),
                                    ),
                                    SizedBox(height: kDefaultPadding),
                                    Container(
                                      height: 80,
                                      child: RoundedButton(
                                        text: "Create",
                                        press: () {
                                          concatPrompts();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Popup title"),
                                                content: Text(prompt),
                                                actions: <Widget>[
                                                  Container(
                                                    height: 80,
                                                    width: 500,
                                                    child: RoundedButton(
                                                      text: "OK",
                                                      press: () {
                                                        generateImage();
                                                        Navigator.of(context)
                                                            .pop();
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
