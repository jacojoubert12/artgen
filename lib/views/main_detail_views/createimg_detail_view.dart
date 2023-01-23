import 'dart:convert';
import 'package:artgen/components/horisontal_image_listview.dart';
import 'package:artgen/components/mqtt_client.dart';
import 'package:artgen/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../constants.dart';
import 'components/header.dart';
import 'image_details_view.dart';

import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

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
  List<String> generatedImgUrls = [
    "http://localhost:5000/output/" + "output.png"
  ];

  bool loading = false;
  String prompt = "";
  String negprompt = "";
  String _promptTxt = "";
  String _negpromptTxt = "";
  double _samplingStepsSliderValue = 20;
  double _resolutionSliderValue = 20;
  double _widthliderValue = 512;
  double _heightSliderValue = 512;
  double _guidanceScaleSliderValue = 15;
  // double _batchCountSliderValue = 1;
  double _batchSizeSliderValue = 1;

  final client = MqttServerClient('68.183.44.212', '');

  // https://github.com/shamblett/mqtt_client/blob/master/example/mqtt_server_client.dart
  Future<int> mqtt() async {
    return mqtt_client_connections();
  }

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
    final query = {
      'prompt': prompt + " ((" + _promptTxt + "))",
      "negprompt": negprompt + " " + _negpromptTxt,
      "steps": _samplingStepsSliderValue,
      "guidance": _guidanceScaleSliderValue,
      "width": _widthliderValue,
      "height": _heightSliderValue,
      // "batch_count": _batchCountSliderValue;
      "batch_size": _batchSizeSliderValue
    };
    print(query);
    String topic = 'test-topic';

    final uri = Uri.http('localhost:5000', '/');

    final response = await http.post(
      uri,
      body: jsonEncode(query),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var images = data['images'];
      print(images);
      generatedImgUrls.clear();
      setState(() {
        for (img in images) {
          generatedImgUrls.add("http://localhost:5000/" + img);
        }
      });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // Header(),
              // Divider(thickness: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CircleAvatar(
                      // maxRadius: 24,
                      // backgroundColor: Colors.transparent,
                      // backgroundImage: AssetImage(emails[1].image),
                      // ),
                      // SizedBox(width: kDefaultPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //       ),
                            //     ),
                            //     SizedBox(width: kDefaultPadding / 2),
                            //     Text(
                            //       DateTime.now().toString(),
                            //       style: Theme.of(context).textTheme.caption,
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: kDefaultPadding),
                            LayoutBuilder(
                              builder: (context, constraints) => SizedBox(
                                width: constraints.maxWidth > 850
                                    ? 800
                                    : constraints.maxWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: _selectedImageUrls.length == 0
                                          ? 0
                                          : 100,
                                      child: ImageListView(
                                        updateSelectedImages:
                                            widget.updateSelectedImages,
                                        selectedImages: _selectedImages,
                                        selectedImageUrls: _selectedImageUrls,
                                      ),
                                    ),
                                    // SizedBox(height: kDefaultPadding),
                                    SizedBox(height: kDefaultPadding),
                                    TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      onChanged: (value) {
                                        _promptTxt = value;
                                      },
                                      decoration: InputDecoration(
                                        label: Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[
                                              WidgetSpan(
                                                child: Text(
                                                  'Prompt',
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: Text(
                                                  '',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: kDefaultPadding),
                                    TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      onChanged: (value) {
                                        _negpromptTxt = value;
                                      },
                                      decoration: InputDecoration(
                                        label: Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[
                                              WidgetSpan(
                                                child: Text(
                                                  'Negative Prompt',
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: Text(
                                                  '',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: kDefaultPadding),
                                    Text("Sampling Steps"),
                                    Slider(
                                      value: _samplingStepsSliderValue,
                                      max: 150,
                                      min: 1,
                                      divisions: 149,
                                      label: _samplingStepsSliderValue
                                          .round()
                                          .toString(),
                                      onChanged: (double value) {
                                        setState(() {
                                          _samplingStepsSliderValue = value;
                                        });
                                      },
                                    ),
                                    // SizedBox(height: kDefaultPadding),
                                    Text("Resolution"),
                                    Slider(
                                      value: _resolutionSliderValue,
                                      max: 150,
                                      min: 1,
                                      divisions: 149,
                                      label: _resolutionSliderValue
                                          .round()
                                          .toString(),
                                      onChanged: (double value) {
                                        setState(() {
                                          _resolutionSliderValue = value;
                                        });
                                      },
                                    ),
                                    // SizedBox(height: kDefaultPadding),
                                    Text("Width"),
                                    Slider(
                                      value: _widthliderValue,
                                      max: 2048,
                                      min: 64,
                                      divisions: 1984,
                                      label:
                                          _widthliderValue.round().toString(),
                                      onChanged: (double value) {
                                        setState(() {
                                          _widthliderValue = value;
                                        });
                                      },
                                    ),
                                    // SizedBox(height: kDefaultPadding),
                                    Text("Height"),
                                    Slider(
                                      value: _heightSliderValue,
                                      max: 2048,
                                      min: 64,
                                      divisions: 1984,
                                      label:
                                          _heightSliderValue.round().toString(),
                                      onChanged: (double value) {
                                        setState(() {
                                          _heightSliderValue = value;
                                        });
                                      },
                                    ),
                                    // SizedBox(height: kDefaultPadding),
                                    Text("Guidance Scale"),
                                    Slider(
                                      value: _guidanceScaleSliderValue,
                                      max: 30,
                                      min: 1,
                                      divisions: 29,
                                      label: _guidanceScaleSliderValue
                                          .round()
                                          .toString(),
                                      onChanged: (double value) {
                                        setState(() {
                                          _guidanceScaleSliderValue = value;
                                        });
                                      },
                                    ),
                                    // SizedBox(height: kDefaultPadding),
                                    // Text("Batch Count"),
                                    // Slider(
                                    //   value: _batchCountSliderValue,
                                    //   max: 100,
                                    //   min: 1,
                                    //   divisions: 99,
                                    //   label: _batchCountSliderValue
                                    //       .round()
                                    //       .toString(),
                                    //   onChanged: (double value) {
                                    //     setState(() {
                                    //       _batchCountSliderValue = value;
                                    //     });
                                    //   },
                                    // ),
                                    // SizedBox(height: kDefaultPadding),
                                    Text("Number of Images"),
                                    Slider(
                                      value: _batchSizeSliderValue,
                                      max: 100,
                                      min: 1,
                                      divisions: 99,
                                      label: _batchSizeSliderValue
                                          .round()
                                          .toString(),
                                      onChanged: (double value) {
                                        setState(() {
                                          _batchSizeSliderValue = value;
                                        });
                                      },
                                    ),
                                    SizedBox(height: kDefaultPadding),
                                    loading
                                        ? CircularProgressIndicator()
                                        : Container(
                                            child: GridView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  generatedImgUrls.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 5,
                                                childAspectRatio: 1,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Container(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return ImageDetailsModal();
                                                        },
                                                      );
                                                      setState(() {});
                                                    },
                                                    child: Image.network(
                                                        generatedImgUrls[
                                                            index]),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                    SizedBox(height: kDefaultPadding),
                                    Container(
                                      height: 80,
                                      child: RoundedButton(
                                        text: "Generate",
                                        press: () {
                                          concatPrompts();
                                          setState(() {
                                            loading = true;
                                          });
                                          generateImage();
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
