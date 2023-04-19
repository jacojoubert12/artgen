import 'dart:convert';

import 'package:artgen/components/rounded_button.dart';
import 'package:artgen/constants.dart';
import 'package:artgen/responsive.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:artgen/views/main_detail_views/createimg_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class ImageDetailsModal extends StatefulWidget {
  ImageDetailsModal({Key? key, this.selectedImageUrl, this.selectedImageMeta})
      : super(key: key);
  final selectedImageUrl;
  final selectedImageMeta;

  @override
  _ImageDetailsModalState createState() => _ImageDetailsModalState();
}

class _ImageDetailsModalState extends State<ImageDetailsModal> {
  String _avatarImage =
      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg';

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
    } else if (data.containsKey('_source') &&
        data['_source'].containsKey('details')) {
      values = data['_source']['details']['parameters'];
    } else if (data.containsKey('_source') &&
        data['_source'].containsKey('info')) {
      values = data['_source']['details']['info'];
    }

    if (values != null) {
      prompt = values['prompt'];
      neg_prompt = values['negative_prompt'];
      width = values['width'];
      height = values['height'];
      steps = values['steps'];
      guidance = values['cfg_scale'];
    }

    super.initState();
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
