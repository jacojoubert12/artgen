import 'dart:convert';
import 'dart:math';

import 'package:artgen/constants.dart';
import 'package:artgen/responsive.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:artgen/views/main_detail_views/createimg_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class ImageDetailsModal extends StatefulWidget {
  ImageDetailsModal(
      {Key? key,
      this.selectedImageUrl,
      this.selectedImageMeta,
      required this.onDelete})
      : super(key: key);
  final selectedImageUrl;
  final selectedImageMeta;
  final Function onDelete;

  @override
  _ImageDetailsModalState createState() => _ImageDetailsModalState();
}

class _ImageDetailsModalState extends State<ImageDetailsModal> {
  String _avatarImage =
      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg';

  String uid = '';
  String prompt = '';
  String neg_prompt = '';
  int width = 0;
  int height = 0;
  int steps = 0;
  double guidance = 0;
  //seed needed at some point?

  @override
  void initState() {
    // print(widget.selectedImageMeta);
    print("Selected Image details:");
    print(widget.selectedImageMeta);
    var data = widget.selectedImageMeta;
    var values;
    print(data.runtimeType);

    if (data.containsKey('details')) {
      values = data['details']['parameters'];
      values['user'] = data['user'];
    } else if (data.containsKey('_source') &&
        data['_source'].containsKey('details')) {
      values = data['_source']['details']['parameters'];
      values['user'] = data['_source']['user'];
    } else if (data.containsKey('_source') &&
        data['_source'].containsKey('info')) {
      values = data['_source']['details']['info'];
      values['user'] = data['_source']['user'];
    }

    if (values != null) {
      prompt = values['prompt'];
      neg_prompt = values['negative_prompt'];
      width = values['width'];
      height = values['height'];
      steps = values['steps'];
      guidance = values['cfg_scale'];
      uid = values['user'];
    }

    print("UID:");
    print(uid);

    super.initState();
  }

  Future<void> downloadAndSaveImage(String imageUrl, String fileName) async {
    // Download the image
    final response = await http.get(Uri.parse(imageUrl));

    if (kIsWeb) {
      // Web
      final mimeType =
          response.headers['content-type'] ?? 'application/octet-stream';
      final blob = html.Blob([response.bodyBytes], mimeType);
      final anchor =
          html.AnchorElement(href: html.Url.createObjectUrlFromBlob(blob));
      anchor.download = fileName;
      anchor.click();
      anchor.remove();
    } else {
      // Get the local storage directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        throw UnsupportedError('Unsupported platform');
      }

      // Create the file with the given file name in the local storage directory
      final file = File('${directory?.path}/$fileName');

      // Write the downloaded image data to the file
      await file.writeAsBytes(response.bodyBytes);
    }
  }

  bool canDelete() {
    print("admins:");
    print(user.admins);
    if (user.user?.uid == uid || user.admins.contains(user.user?.uid))
      return true;
    else
      return false;
  }

  Future<void> deleteImage(String filename) async {
    final url = Uri.parse("https://ws.artgen.fun:12004/delete_image");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: json.encode({"filename": filename}),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print("Deleted document IDs: ${jsonResponse['deleted_document_ids']}");
    } else {
      print("Failed to delete documents. Status code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user.user?.photoURL != null) {
      setState(() {
        _avatarImage = user.user!.photoURL!;
      });
    }
    return Scaffold(
      // key: _scaffoldKey,
      backgroundColor: Color.fromARGB(0, 33, 149, 243),
      body: Center(
        child: Container(
          width: Responsive.isDesktop(context)
              ? MediaQuery.of(context).size.width * 0.6
              : MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: BoxDecoration(
              color: kBgDarkColor,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (!Responsive.isDesktop(context))
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: kButtonLightPurple,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  if (!Responsive.isDesktop(context)) SizedBox(width: 5),
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Image.network(
                    widget.selectedImageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Share
                    ElevatedButton(
                      child: Icon(
                        Icons.share,
                        size: 20.0,
                      ),
                      onPressed: () {
                        Share.share(
                            'check out the Image I have generated with ArtGen.fun ${widget.selectedImageUrl}'); //make thumbnail? make link not expire
                      },
                      style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          primary: Color.fromARGB(255, 181, 9, 130),
                          shape: CircleBorder()),
                    ),

                    //Image2Image
                    ElevatedButton(
                      child: Icon(
                        Icons.image_rounded,
                        size: 20.0,
                      ),
                      onPressed: () {
                        user.widthSliderValue = width.toDouble();
                        user.heightSliderValue = height.toDouble();
                        user.samplingStepsSliderValue = steps.toDouble();
                        user.guidanceScaleSliderValue = guidance;
                        Set<String> selectedImageUrl = Set();
                        selectedImageUrl.add(widget.selectedImageUrl);
                        var selectedImages = [
                          {'img2img': widget.selectedImageUrl}
                        ];
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CreateImgDetailView(
                                selectedImageUrls: selectedImageUrl,
                                selectedImages: selectedImages.toSet(),
                                img2ImgImages: [widget.selectedImageUrl]);
                          },
                        );
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          primary: Color.fromARGB(255, 181, 9, 130),
                          shape: CircleBorder()),
                    ),
                    prompt.length > 30
                        ? ElevatedButton(
                            child: Icon(
                              Icons.refresh,
                              size: 20.0,
                            ),
                            onPressed: () {
                              user.widthSliderValue = width.toDouble();
                              user.heightSliderValue = height.toDouble();
                              user.samplingStepsSliderValue = steps.toDouble();
                              user.guidanceScaleSliderValue = guidance;
                              var selectedImages = [];
                              selectedImages.add({});
                              selectedImages[0] = {
                                '_source': {
                                  'details': {
                                    'parameters': {
                                      'prompt': prompt,
                                      'negative_prompt': neg_prompt
                                    }
                                  }
                                }
                              };
                              Set<String> selectedImageUrl = Set();
                              selectedImageUrl.add(widget.selectedImageUrl);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CreateImgDetailView(
                                      selectedImageUrls: selectedImageUrl,
                                      selectedImages: selectedImages.toSet());
                                },
                              );
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                primary: Color.fromARGB(255, 181, 9, 130),
                                shape: CircleBorder()),
                          )
                        : Text(''),
                    ElevatedButton(
                      child: Icon(
                        Icons.download,
                        size: 20.0,
                      ),
                      onPressed: () {
                        int startIndex =
                            widget.selectedImageUrl.indexOf('images/') +
                                'images/'.length;
                        int endIndex = widget.selectedImageUrl.indexOf('.png') +
                            '.png'.length;
                        String selectedImageUrl = widget.selectedImageUrl
                            .substring(startIndex, endIndex);
                        deleteImage(selectedImageUrl);
                        downloadAndSaveImage(
                                widget.selectedImageUrl, selectedImageUrl)
                            .then((_) {
                          print('Image downloaded and saved successfully');
                        }).catchError((error) {
                          print('Error downloading and saving image: $error');
                        });
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          primary: Color.fromARGB(255, 181, 9, 130),
                          shape: CircleBorder()),
                    ),
                    canDelete()
                        ? ElevatedButton(
                            child: Icon(
                              Icons.delete,
                              size: 20.0,
                            ),
                            onPressed: () {
                              int startIndex =
                                  widget.selectedImageUrl.indexOf('images/') +
                                      'images/'.length;
                              int endIndex =
                                  widget.selectedImageUrl.indexOf('.png') +
                                      '.png'.length;

                              String selectedImageUrl = widget.selectedImageUrl
                                  .substring(startIndex, endIndex);
                              deleteImage(selectedImageUrl);
                              widget.onDelete(widget.selectedImageUrl);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                primary: Color.fromARGB(255, 181, 9, 130),
                                shape: CircleBorder()),
                          )
                        : Text(''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
