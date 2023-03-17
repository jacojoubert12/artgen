import 'dart:convert';
import 'package:artgen/auth_gate.dart';
import 'package:artgen/components/horisontal_image_listview.dart';
// import 'package:artgen/components/mqtt_client_manager.dart';
import 'package:artgen/components/rounded_button.dart';
import 'package:artgen/components/settings_navigation_drawer.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../constants.dart';
import '../../responsive.dart';
import 'image_details_view.dart';

import 'dart:async';
import 'dart:io';
import 'package:mqtt5_client/mqtt5_browser_client.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class CreateImgDetailView extends StatefulWidget {
  CreateImgDetailView({
    Key? key,
    this.setViewMode,
    this.selectedImages,
    this.selectedImageUrls,
    this.updateSelectedImages,
    this.showDetailView,
  }) : super(key: key);
  final selectedImages;
  final selectedImageUrls;
  final Function? updateSelectedImages;
  final Function? showDetailView;
  final Function? setViewMode;

  @override
  State<CreateImgDetailView> createState() => _CreateImgDetailViewState();
}

class _CreateImgDetailViewState extends State<CreateImgDetailView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Set<dynamic>? _selectedImages;
  Set<String>? _selectedImageUrls;
  List<String> generatedImgUrls = [
    "assets/images/tmp_image.png"
    // "http://localhost:5000/output/" + "output.png"
    // "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg"
  ];

  bool loading = false;
  int retries = 0;
  int timeoutRetries = 0;
  int retryDurationInSeconds = 60;
  bool uploading = false;
  String prompt = "";
  String negprompt = "";
  String _promptTxt = "";
  String _negpromptTxt = "";
  String deviceId = "";
  Map<String, dynamic> query = {};
  String _avatarImage =
      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg';

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final client =
      MqttBrowserClient('ws://68.183.44.212', 'flutter-browser-client');

  @override
  void initState() {
    super.initState();
    _selectedImages = widget.selectedImages;
    _selectedImageUrls = widget.selectedImageUrls;

    setupMqttClient();
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }

  Future<void> startRetryTimer() async {
    // setState(() {
    //   _isRunning = true;
    // });

    // Wait for the timer duration
    await Future.delayed(Duration(seconds: retryDurationInSeconds));

    // Execute the function
    if (loading && timeoutRetries < 5) {
      generateImage();
      timeoutRetries++;
    } else if (timeoutRetries >= 5) {
      timeoutRetries = 0;
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> mqttConnect() async {
    client.keepAlivePeriod = 3600;

    client.onConnected = () {
      print('Connected');
    };

    client.onDisconnected = () {
      print('Disconnected');
      if (loading) {
        retries++;
        if (retries > 5) {
          retries = 0;
        } else {
          // mqttConnect();
          generateImage();
        }
      }
    };

    client.onSubscribed = (topic) {
      print('Subscribed to $topic');
    };

    print("Check Connection Status");
    if (client.connectionStatus != MqttConnectionState.connected) {
      print("Connect to server");
      await client.connect();
      print("Subscribe");
      client.subscribe(user.subTopic, MqttQos.exactlyOnce);
      print("Listen for updates");

      client.updates.listen((dynamic c) {
        final MqttPublishMessage recMess = c[0].payload;
        final pt =
            MqttUtilities.bytesToStringAsString(recMess.payload.message!);
        print(
            'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
        showGeneratedImages(pt);
      });
    }
  }

  Future<void> setupMqttClient() async {
    await mqttConnect();
    client.subscribe(user.subTopic, MqttQos.exactlyOnce);
  }

  void showGeneratedImages(String message) {
    final Set<String> imageUrls = Set();
    var response = jsonDecode(message);
    // print(response);
    for (var img in response) {
      print(img);
      imageUrls.add(img);
    }
    setState(() {
      generatedImgUrls = imageUrls.toList();
      loading = false;
    });
  }

  String escapeDangerousCharacters(String inputString) {
    String sanitizedString = "";
    for (int i = 0; i < inputString.length; i++) {
      int codeUnit = inputString.codeUnitAt(i);
      if (codeUnit < 128) {
        sanitizedString += inputString[i];
      }
    }
    String regex =
        r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]+';
    sanitizedString.replaceAll(RegExp(regex, unicode: true), '');
    print('sanitizedString');
    print(sanitizedString);
    return sanitizedString
        .replaceAll('\\', '\\\\')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t')
        .replaceAll('"', '\\"')
        .replaceAll('“', '"')
        .replaceAll('”', '"')
        .replaceAll('”', '"')
        .replaceAll('“', '"')
        .replaceAll('”', '"');
  }

  concatPrompts() {
    prompt = "";
    negprompt = "";
    for (var jsonString in _selectedImages!) {
      if (jsonString != null) {
        // print(jsonString);
        var jsonP = jsonString['_source']['details']['parameters']['prompt'];
        var jsonNP =
            jsonString['_source']['details']['parameters']['negative_prompt'];
        prompt += jsonP + " ";
        negprompt += jsonNP + " ";
        print(prompt);
        print(negprompt);
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
      'prompt': escapeDangerousCharacters(prompt),
      "negprompt": escapeDangerousCharacters(negprompt),
      "steps": user.samplingStepsSliderValue,
      "guidance": user.guidanceScaleSliderValue,
      "width": user.widthSliderValue,
      "height": user.heightSliderValue,
      // "batch_count": _batchCountSliderValue;
      "batch_size": user.batchSizeSliderValue,
      "response_topic": user.subTopic,
      "user": user.user?.uid,
    };
  }

  generateImage() async {
    if (client.connectionStatus != MqttConnectionState.connected) {
      await mqttConnect();
    }
    final builder = MqttPayloadBuilder();
    builder.addString(jsonEncode(query));
    client.publishMessage(user.pubTopic, MqttQos.exactlyOnce, builder.payload!);
    print("JSON Encoded query:");
    print(jsonEncode(query));

    setState(() {
      loading = true;
    });
    startRetryTimer();
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
        color: kBgDarkColor,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: kDefaultPadding),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: !Responsive.isDesktop(context)
                        ? Container(
                            width: 45,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: kButtonLightPurple,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          )
                        : SizedBox(
                            width: 45,
                          ),
                  ),
                  if (!Responsive.isDesktop(context)) SizedBox(width: 5),
                  // Expanded(
                  //   flex: 1,
                  //   child: Responsive.isMobile(context)
                  //       ? Container(
                  //           margin: EdgeInsets.only(left: 20),
                  //           width: 45,
                  //           height: 45,
                  //           child: CircleAvatar(
                  //             backgroundImage: NetworkImage(_avatarImage),
                  //           ),
                  //         )
                  //       : SizedBox(
                  //           width: 45,
                  //         ),
                  // ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      child: Text(
                        "Create Image",
                        style: TextStyle(
                          fontFamily:
                              'custom font', // remove this if don't have custom font
                          fontSize: 20.0, // text size
                          color: Color.fromARGB(255, 144, 142, 142),
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(left: 40),
                  //   width: 40,
                  //   height: 40,
                  //   child: CircleAvatar(
                  //     backgroundImage: NetworkImage(_avatarImage),
                  //   ),
                  // ),

                  Expanded(
                    flex: 1,
                    child: Responsive.isMobile(context)
                        ? Container(
                            margin: EdgeInsets.only(left: 20),
                            width: 45,
                            height: 45,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(_avatarImage),
                            ),
                          )
                        : SizedBox(
                            width: 45,
                          ),
                  ),
                ],
              ),
              // Row(
              //   // height: 35.0,
              //   // width: 50,
              //   children: [
              //     Responsive.isMobile(context)
              //         ? Align(
              //             alignment: Alignment.topLeft,
              //             child: ElevatedButton(
              //               child: Icon(
              //                 Icons.arrow_back,
              //                 size: 30.0,
              //                 color: kButtonLightPurple,
              //               ),
              //               onPressed: () {
              //                 Navigator.of(context).pop();
              //               },
              //               style: ElevatedButton.styleFrom(
              //                   primary: Color.fromARGB(0, 181, 9, 129),
              //                   onPrimary: Colors.black,
              //                   shape: CircleBorder()),
              //             ),
              //           )
              //         : Text(''),
              //     // Container(),
              //     Positioned(
              //       // top: MediaQuery.of(context).size.height / 8,
              //       // left: MediaQuery.of(context).size.width / 2 - 50,
              //       // alignment: Alignment.topRight,
              //       child: Container(
              //         alignment: Alignment.topRight,
              //         child: ElevatedButton(
              //           child: Icon(
              //             Icons.settings,
              //             size: 30.0,
              //           ),
              //           onPressed: () {
              //             showDialog(
              //               context: context,
              //               builder: (context) {
              //                 return SettingNavigationDrawer();
              //               },
              //             );
              //           },
              //           style: ElevatedButton.styleFrom(
              //               primary: Color.fromARGB(255, 181, 9, 130),
              //               onPrimary: Colors.black,
              //               shape: CircleBorder()),
              //         ),
              //       ),
              //     ),
              //     Positioned(
              //       // top: MediaQuery.of(context).size.height / 8,
              //       // left: MediaQuery.of(context).size.width / 2 - 50,
              //       child: Container(
              //         // margin: EdgeInsets.only(left: 40),
              //         width: 40,
              //         height: 40,
              //         child: CircleAvatar(
              //           backgroundImage: NetworkImage(_avatarImage),
              //         ),
              //       ),
              //     ),
              //     // Positioned(
              //     //   top: MediaQuery.of(context).size.height / 8,
              //     //   left: MediaQuery.of(context).size.width / 2 - 50,
              //     Container(
              //       margin: EdgeInsets.only(left: 20),
              //       width: 45,
              //       height: 45,
              //       child: CircleAvatar(
              //         backgroundImage: NetworkImage(_avatarImage),
              //       ),
              //     ),
              //     // ),
              //   ],
              // ),
              SizedBox(height: kDefaultPadding),
              if (Responsive.isMobile(context))
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20.0),
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
              SizedBox(height: kDefaultPadding / 2),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 77, 75, 75),
                      width: 2.0,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(5),
                ),
                // height: _selectedImageUrls!.length == 0 ? 0 : 100,
                child: Expanded(
                  child: (_selectedImageUrls!.length > 0)
                      ? ImageListView(
                          updateSelectedImages: widget.updateSelectedImages,
                          selectedImages: _selectedImages,
                          selectedImageUrls: _selectedImageUrls,
                        )
                      : Text(
                          "Select images in search view if you would like to make use of their prompts",
                          style: TextStyle(
                            fontFamily:
                                'custom font', // remove this if don't have custom font
                            fontSize: 12.0, // text size
                            color: Color.fromARGB(255, 144, 142, 142),

                            // text color
                          ),
                        ),
                ),
              ),
              SizedBox(height: kDefaultPadding),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (value) {
                  _promptTxt = value;
                },
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 144, 142, 142),
                  ),
                  // hintText: "Search for specific topics",
                  contentPadding: EdgeInsets.symmetric(vertical: 30),
                  label: Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        WidgetSpan(
                          child: Text(
                            'Prompt',
                            style: TextStyle(
                              fontFamily:
                                  'custom font', // remove this if don't have custom font
                              fontSize: 12.0, // text size
                              color: Color.fromARGB(255, 144, 142, 142),

                              // text color
                            ),
                          ),
                        ),
                        WidgetSpan(
                          child: Text(
                            '',
                            style: TextStyle(color: Colors.red),
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
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  label: Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        WidgetSpan(
                          child: Text(
                            'Negative Prompt',
                            style: TextStyle(
                              fontFamily:
                                  'custom font', // remove this if don't have custom font
                              fontSize: 12.0, // text size
                              color: Color.fromARGB(255, 144, 142, 142),

                              // text color
                            ),
                          ),
                        ),
                        WidgetSpan(
                          child: Text(
                            '',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: kDefaultPadding),
              loading
                  ? Expanded(
                      child: Column(children: [
                      SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator()),
                      Text('')
                    ]))
                  : Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: generatedImgUrls.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: generatedImgUrls.length < 3 ? 1 : 3,
                          childAspectRatio:
                              user.heightSliderValue / user.widthSliderValue,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ImageDetailsModal(
                                      selectedImageUrl: generatedImgUrls[index],
                                    );
                                  },
                                );
                                setState(() {});
                              },
                              child: FadeInImage(
                                placeholder:
                                    NetworkImage("assets/images/tmp_image.png"),
                                image: NetworkImage(generatedImgUrls[index]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(height: kDefaultPadding),
              Row(
                children: [
                  Expanded(
                    child: Text(''),
                  ),
                  // loading
                  //     ? Text('')
                  //     :
                  Container(
                    height: 40,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 61, 2, 50),
                          Color.fromARGB(255, 10, 6, 20)
                        ])),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Generate'),
                      onPressed: () {
                        concatPrompts();
                        user.showLogin(context, query)
                            ? {
                                //Move to response on success
                                user.imagesToGenerate =
                                    (user.batchSizeSliderValue as int?)!,
                                // concatPrompts(),
                                // setState(() {
                                // loading = true;
                                // }),
                                generateImage()
                              }
                            : showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Popup title"),
                                    content:
                                        Text("You have reached your limit"),
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
                  SizedBox(width: kDefaultPadding),
                  Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 61, 2, 50),
                          Color.fromARGB(255, 10, 6, 20)
                        ])),
                    child: uploading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text('Upload'),
                            onPressed: () async {
                              setState(() {
                                uploading = true;
                              });
                              uploadFile();
                            },
                          ),
                  ),
                  SizedBox(height: kDefaultPadding),
                  Container(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      child: Icon(
                        Icons.settings,
                        size: 30.0,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SettingNavigationDrawer();
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 181, 9, 130),
                          onPrimary: Colors.black,
                          shape: CircleBorder()),
                    ),
                  ),
                  Expanded(
                    child: Text(''),
                  ),
                ],
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
