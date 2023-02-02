import 'dart:convert';
import 'package:artgen/auth_gate.dart';
import 'package:artgen/components/horisontal_image_listview.dart';
import 'package:artgen/components/mqtt_client_manager.dart';
import 'package:artgen/components/rounded_button.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:platform_device_id/platform_device_id.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../constants.dart';
import 'components/header.dart';
import 'image_details_view.dart';

import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class CreateImgDetailView extends StatefulWidget {
  CreateImgDetailView(
      {Key? key,
      this.selectedImages,
      this.selectedImageUrls,
      this.updateSelectedImages})
      : super(key: key);
  final selectedImages;
  final selectedImageUrls;
  final Function? updateSelectedImages;

  @override
  State<CreateImgDetailView> createState() => _CreateImgDetailViewState();
}

class _CreateImgDetailViewState extends State<CreateImgDetailView> {
  Set<dynamic>? _selectedImages;
  Set<String>? _selectedImageUrls;
  List<String> generatedImgUrls = [
    // "http://localhost:5000/output/" + "output.png"
    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg"
  ];

  bool loading = false;
  bool uploading = false;
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
  String deviceId = "";
  Map<String, dynamic> query = {};

  MQTTClientManager mqttClientManager = MQTTClientManager();
  final String pubTopic = "img_gen_requests";
  String subTopic = "img_gen_response/" + user.user!.uid;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _selectedImages = widget.selectedImages;
    _selectedImageUrls = widget.selectedImageUrls;
    _getInfo();

    setupMqttClient();
    setupUpdatesListener();
  }

  @override
  void dispose() {
    mqttClientManager.disconnect();
    super.dispose();
  }

  void _getInfo() async {
    // Get device id
    // String? result = await PlatformDeviceId.getDeviceId;

    // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"

    // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    // print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"

    // WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    // print('Running on ${webBrowserInfo.userAgent}');

    // Update the UI
    setState(() {
      // deviceId = result!;
      // print(deviceId);
    });
  }

  //TODO Reconnections and Timeouts on requests
  Future<void> setupMqttClient() async {
    // subTopic += "deviceId!";
    await mqttClientManager.connect();
    mqttClientManager.subscribe(subTopic);
  }

  void setupUpdatesListener() {
    mqttClientManager
        .getMessagesStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('MQTTClient::Message received on topic: <${c[0].topic}> is $pt\n');
      //   generatedImgUrls.clear();
      print(jsonDecode(pt));
      final List<String> imageUrls = [];
      for (var url in jsonDecode(pt)) {
        String urlString = url.toString();
        String filename = urlString.substring(urlString.length - 40);
        ;
        print(filename);
        String storage_ref =
            await storage.ref('images/$filename').getDownloadURL();
        imageUrls.add(storage_ref);
      }
      setState(() {
        generatedImgUrls = imageUrls;
        loading = false;
      });
    });
  }

  concatPrompts() {
    prompt = "";
    negprompt = "";
    for (var jsonString in _selectedImages!) {
      if (jsonString != null) {
        var json = jsonEncode(jsonString['prompt']);
        prompt += jsonDecode(json) + " ";

        //Null checks etc?
        // json = jsonEncode(jsonString['negprompt']);
        // negprompt += jsonDecode(json) + " ";
      }
    }
    prompt += " ((" + _promptTxt + "))";
    negprompt += " ((" + _negpromptTxt + "))";
    print(prompt);
    print(negprompt);

    query = {
      'prompt': prompt, // + " ((" + _promptTxt + "))",
      "negprompt": negprompt + " " + _negpromptTxt,
      "steps": _samplingStepsSliderValue,
      "guidance": _guidanceScaleSliderValue,
      "width": _widthliderValue,
      "height": _heightSliderValue,
      // "batch_count": _batchCountSliderValue;
      "batch_size": _batchSizeSliderValue,
      "response_topic": subTopic,
      "user": user.user?.uid,
    };
  }

  generateImage() async {
    // final response = await http.get('http://localhost:5000?name=John');
    print(query);
    mqttClientManager.publishMessage(pubTopic, jsonEncode(query));

    setState(() {
      loading = true;
    });
  }

  Future<void> uploadFile() async {
    String filename = "";
    if (kIsWeb) {
      final result = await FilePickerWeb.platform
          .pickFiles(allowMultiple: false, type: FileType.image);

      if (result == null) {
        setState(() {
          uploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No file was selected"),
          ),
        );
      } else {
        Uint8List uploadfile = result.files.single.bytes!;
        filename = result.files.single.name;
        if (uploadfile.length / 1000.0 / 1000.0 > 3) {
          setState(() {
            uploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Upload file too large. Max size = 3MB"),
            ),
          );
          print("upload size too large");
        }

        try {
          await storage
              .ref('uploads/$filename')
              .putData(uploadfile, SettableMetadata(contentType: 'image/png'));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Upload completed")),
          );
          print("Upload done");
        } on firebase_core.FirebaseException catch (e) {
          print(e);
        }
      }
    } else {
      final result = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No file was selected"),
          ),
        );
      } else {
        final path = result.files.single.path!;
        filename = result.files.single.name;
        File file = File(path);
        int len = await file.length();
        if (len / 1000.0 / 1000.0 > 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Upload file too large. Max size = 3MB"),
            ),
          );
        }

        try {
          await storage.ref('uploads/$filename').putFile(file);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Upload completed")),
          );
          print("Upload done");
        } on firebase_core.FirebaseException catch (e) {
          print(e);
        }
      }
    }

    String url = await storage.ref('uploads/$filename').getDownloadURL();

    setState(() {
      _selectedImageUrls!.add(url);
      _selectedImages!.add(url);
      uploading = false;
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) => SizedBox(
                                width: constraints.maxWidth > 850
                                    ? 800
                                    : constraints.maxWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: _selectedImageUrls!.length == 0
                                          ? 0
                                          : 100,
                                      child: Expanded(
                                        child: (_selectedImageUrls!.length > 0)
                                            ? ImageListView(
                                                updateSelectedImages:
                                                    widget.updateSelectedImages,
                                                selectedImages: _selectedImages,
                                                selectedImageUrls:
                                                    _selectedImageUrls,
                                              )
                                            : Text(
                                                "Select images in search view if you would like to make use of their prompts"),
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
                                                          return ImageDetailsModal(
                                                            selectedImageUrl:
                                                                generatedImgUrls[
                                                                    index],
                                                          );
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
                                          user.showLogin(context, query)
                                              ? {
                                                  //Move to response on success
                                                  user.imagesToGenerate =
                                                      (_batchSizeSliderValue
                                                          as int?)!,
                                                  // concatPrompts(),
                                                  setState(() {
                                                    loading = true;
                                                  }),
                                                  // generateImage() //Put back!
                                                }
                                              : showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text("Popup title"),
                                                      content: Text(
                                                          "You have reached your limit"),
                                                      actions: <Widget>[
                                                        Container(
                                                          height: 80,
                                                          width: 500,
                                                          child: RoundedButton(
                                                            text: "OK",
                                                            press: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 80,
                                      child: uploading
                                          ? CircularProgressIndicator()
                                          : RoundedButton(
                                              text: "Upload",
                                              press: () async {
                                                setState(() {
                                                  uploading = true;
                                                });
                                                uploadFile();
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
