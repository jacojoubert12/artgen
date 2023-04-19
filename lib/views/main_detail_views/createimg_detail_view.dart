import 'dart:convert';
import 'package:universal_platform/universal_platform.dart';
import 'package:artgen/components/adMob_view.dart';
import 'package:artgen/components/horisontal_image_listview.dart';
import 'package:artgen/components/rounded_button.dart';
import 'package:artgen/components/settings_navigation_drawer.dart';
import 'package:artgen/models/websockets.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../constants.dart';
import '../../responsive.dart';
import 'image_details_view.dart';

import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:artgen/components/file_picker_mobile.dart'
    if (dart.library.html) 'package:artgen/components/file_picker_web.dart';

class CreateImgDetailView extends StatefulWidget {
  CreateImgDetailView({
    Key? key,
    this.setViewMode,
    this.selectedImages,
    this.selectedImageUrls,
    this.updateSelectedImages,
    this.showDetailView,
    this.img2ImgImages,
  }) : super(key: key);
  final selectedImages;
  final selectedImageUrls;
  final List<String>? img2ImgImages;
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
  Map<String, dynamic> generatedImagesMeta = {};
  List<String> generatedImgUrls = [];

  bool loading = false;
  int retries = 0;
  bool showUpload = true;
  int timeoutRetries = 0;
  int retryDurationInSeconds = 180;
  bool uploading = false;
  List<String> uploadImg2ImgImages = [];
  String pubTopic = '';
  String prompt = "";
  String negprompt = "";
  String _promptTxt = "";
  String _negpromptTxt = "";
  String deviceId = "";
  Map<String, dynamic> query = {};
  String _avatarImage =
      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg';

  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  late MyWebsockets imgGenWs;

  @override
  void initState() {
    super.initState();
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
      bannerAd = AdManager.createBannerAd()..load();
    _selectedImages = widget.selectedImages;
    _selectedImageUrls = widget.selectedImageUrls;
    if (widget.img2ImgImages != null) {
      uploadImg2ImgImages = widget.img2ImgImages!;
      showUpload = false;
    }

    user.loggedInUserFutureForImgGen.then((_) {
      if (user.user?.photoURL != null) {
        setState(() {
          _avatarImage = user.user!.photoURL!;
        });
      }
      setupWebsockets();
    });
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
      bannerAd = AdManager.createBannerAd()..load();
  }

  @override
  void dispose() {
    imgGenWs.close();
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      bannerAd?.dispose();
      interstitialAd?.dispose();
    }
    super.dispose();
  }

  Widget _buildBannerAdWidget() {
    return AdWidget(ad: bannerAd!);
  }

  Future<void> _showInterstitialAd() async {
    interstitialAd = await AdManager.createInterstitialAd();
    await interstitialAd!.show();
  }

  Future<void> _showRewardedAd() async {
    try {
      final RewardedAd rewardedAd = await AdManager.createRewardedAd();
      rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          // Reward the user for watching the ad (e.g., give in-app currency or points)
          print('User earned reward: ${reward.amount} ${reward.type}');
        },
      );
      rewardedAd.fullScreenContentCallback =
          FullScreenContentCallback<RewardedAd>(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          print('Rewarded Ad did dismiss fullscreen content');
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          print('Rewarded Ad failed to show fullscreen content: $error');
          ad.dispose();
        },
      );
    } on Exception catch (e) {
      print('Failed to show Rewarded Ad: $e');
    }
  }

  Future<void> _showRewardedInterstitialAd() async {
    try {
      final RewardedInterstitialAd rewardedInterstitialAd =
          await AdManager.createRewardedInterstitialAd();
      rewardedInterstitialAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          // Reward the user for watching the ad (e.g., give in-app currency or points)
          print('User earned reward: ${reward.amount} ${reward.type}');
        },
      );
      rewardedInterstitialAd.fullScreenContentCallback =
          FullScreenContentCallback<RewardedInterstitialAd>(
        onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
          print('Rewarded Interstitial Ad did dismiss fullscreen content');
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent:
            (RewardedInterstitialAd ad, AdError error) {
          print(
              'Rewarded Interstitial Ad failed to show fullscreen content: $error');
          ad.dispose();
        },
      );
    } on Exception catch (e) {
      print('Failed to show Rewarded Interstitial Ad: $e');
    }
  }

  Future<void> setupWebsockets() async {
    print("setupWebsockets()");
    while (user.user == null) await Future.delayed(Duration(seconds: 1));

    while (user.selectedModel.length == 0)
      await Future.delayed(Duration(seconds: 1));

    imgGenWs = MyWebsockets(
      onMessageReceived: (message) {
        setState(() {
          print("image gen response");
          showGeneratedImages(message);
        });
      },
      topic: "img-gen-url-res-${user.selectedModel}",
    );
  }

  Future<void> startRetryTimer() async {
    await Future.delayed(Duration(seconds: retryDurationInSeconds));
    print("Would have retried");
    if (loading && timeoutRetries < 5) {
      print("Timeout, going to retry");
      // generateImage();
      timeoutRetries++;
    } else if (timeoutRetries >= 1) {
      timeoutRetries = 0;
      setState(() {
        loading = false;
      });
    }
  }

  void showGeneratedImages(String message) {
    List<String> imgUrls = [];

    print(message);
    var jsonData = jsonDecode(message);
    print('Could not do decode?');

    print(jsonData);

    var details = jsonData['details'];
    var info = jsonData['info'];
    var nsfw_probs = jsonData['nsfw_probs'];
    var model = jsonData['model'];
    var host = jsonData['host'];
    var genTimestamp = jsonData['@gen_timestamp'];

    generatedImagesMeta = {
      'details': details,
      'info': info,
      'nsfw_probs': nsfw_probs,
      'model': model,
      'host': host,
      'gen_timestamp': genTimestamp
    };

    print('generatedImagesMeta');
    print(generatedImagesMeta);

    var count = 0;
    if (jsonData['urls'] != null) {
      for (String url in jsonData['urls']) {
        if (nsfw_probs[count] < user.nsfwFilterSliderValue)
          imgUrls.add(url);
        else
          generatedImagesMeta['nsfw_probs'].removeAt(count);
        count += 1;
      }
    }

    print('imgUrls');
    print(imgUrls);

    setState(() {
      generatedImgUrls = imgUrls;
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
        .replaceAll('\\', '')
        .replaceAll('\n', '')
        .replaceAll('\r', '')
        .replaceAll('\t', '')
        .replaceAll('"', '')
        .replaceAll('“', '')
        .replaceAll('”', '')
        .replaceAll('”', '')
        .replaceAll('“', '')
        .replaceAll('”', '');
  }

  concatPrompts() {
    //TODo: Add NLP to cleanup the prompt and remove duplicate sentences when selected images have overlapping prompts
    //Ensure the size #GPT4All? Basically rewrite the prompt to improve it
    print("Before contactPrompts");
    prompt = "";
    negprompt = "";
    print(_selectedImages);
    for (var jsonString in _selectedImages!) {
      print(jsonString);
      if (jsonString != null) {
        print(jsonString);
        if (jsonString.toString().contains('img2img')) continue;
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
      print("After contactPrompts");
    }

    List<String> img2imgList = [];
    for (var uploadedImgUrl in _selectedImageUrls!) {
      if (uploadImg2ImgImages.contains(uploadedImgUrl))
        img2imgList.add(uploadedImgUrl);
    }

    prompt += " ((" + _promptTxt + "))";
    negprompt += " ((" + _negpromptTxt + "))";
    print(prompt);
    print(negprompt);

    query = {
      'prompt': escapeDangerousCharacters(prompt),
      'negprompt': escapeDangerousCharacters(negprompt),
      'steps': user.samplingStepsSliderValue,
      'guidance': user.guidanceScaleSliderValue,
      'width': user.widthSliderValue,
      'height': user.heightSliderValue,
      // "batch_count": _batchCountSliderValue;
      'batch_size': user.batchSizeSliderValue,
      'uid': user.user?.uid,
      'topic': "img-gen-req-${user.selectedModel}"
    };

    if (img2imgList.length > 0) {
      query['init_images'] = img2imgList;
      query['denoising_strength'] = user.denoisingStrengthSliderValue;
    }
  }

  generateImage() async {
    print("Generate Images");
    retryDurationInSeconds = (user.batchSizeSliderValue.toInt() * 180);
    print("JSON Encoded query:");
    print(jsonEncode(query));
    setupWebsockets();
    imgGenWs.sendMessage(query);

    setState(() {
      loading = true;
    });
    startRetryTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    flex: 3,
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      child: Text(
                        "Create Image",
                        style: TextStyle(
                          fontFamily:
                              'custom font', // remove this if don't have custom font
                          fontSize: 20.0, // text size
                          color: kTextColorLightGrey,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: kDefaultPadding),
                    if (Responsive.isMobile(context))
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Selected images",
                          style: TextStyle(
                            fontFamily: 'custom font',
                            fontSize: 15.0,
                            color: kTextColorLightGrey,
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
                      child: (_selectedImageUrls!.length > 0)
                          ? ImageListView(
                              updateSelectedImages: widget.updateSelectedImages,
                              selectedImages: _selectedImages,
                              selectedImageUrls: _selectedImageUrls,
                            )
                          : Text(
                              "Select images in search view to make use of their prompts",
                              style: TextStyle(
                                fontFamily: 'custom font',
                                fontSize: 11.0,
                                color: kTextColorLightGrey,
                              ),
                            ),
                    ),
                    SizedBox(height: kDefaultPadding),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: TextField(
                        style: TextStyle(
                          color: kTextColorLightGrey,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3, // Set max number of lines to 5
                        onChanged: (value) {
                          _promptTxt = value;
                        },
                        cursorColor: Color.fromARGB(255, 77, 75, 75),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: 10,
                            color: kTextColorLightGrey,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 77, 75, 75),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: kButtonLightPurple,
                              width: 1.0,
                            ),
                          ),
                          label: Text.rich(
                            TextSpan(
                              children: <InlineSpan>[
                                WidgetSpan(
                                  child: Text(
                                    'Prompt',
                                    style: TextStyle(
                                      fontFamily: 'custom font',
                                      fontSize: 11.0,
                                      color: kTextColorLightGrey,
                                    ),
                                  ),
                                ),
                                WidgetSpan(
                                  child: Text(
                                    '',
                                    style:
                                        TextStyle(color: kTextColorLightGrey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: TextField(
                        style: TextStyle(
                          color: kTextColorLightGrey,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 2, // Set max number of lines to 5
                        onChanged: (value) {
                          _negpromptTxt = value;
                        },
                        cursorColor: Color.fromARGB(255, 77, 75, 75),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 77, 75, 75),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: kButtonLightPurple,
                              width: 1.0,
                            ),
                          ),
                          label: Text.rich(
                            TextSpan(
                              children: <InlineSpan>[
                                WidgetSpan(
                                  child: Text(
                                    'Negative Prompt',
                                    style: TextStyle(
                                      fontFamily: 'custom font',
                                      fontSize: 12.0,
                                      color: kTextColorLightGrey,
                                    ),
                                  ),
                                ),
                                WidgetSpan(
                                  child: Text(
                                    '',
                                    style:
                                        TextStyle(color: kTextColorLightGrey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              loading
                  ? Expanded(
                      child: Column(children: [
                      SizedBox(height: kDefaultPadding),
                      SizedBox(
                          width: 200,
                          height: 200,
                          child: SpinKitThreeBounce(color: kButtonLightPurple)),
                      Text('')
                    ]))
                  : Expanded(
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          double availableWidth = constraints.maxWidth;
                          double aspectRatio = availableWidth /
                              MediaQuery.of(context).size.height;
                          if (generatedImgUrls.length == 0) {
                            return Container(
                              child: Image.asset('assets/images/tmp_image.png'),
                            );
                          } else if (generatedImgUrls.length == 1) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ImageDetailsModal(
                                      selectedImageUrl: generatedImgUrls[0],
                                      selectedImageMeta: generatedImagesMeta,
                                    );
                                  },
                                );
                                setState(() {});
                              },
                              child: Center(
                                child: FadeInImage(
                                  placeholder:
                                      AssetImage('assets/images/tmp_image.png'),
                                  image: NetworkImage(generatedImgUrls[0]),
                                ),
                              ),
                            );
                          } else {
                            return GridView.builder(
                              shrinkWrap: true,
                              itemCount: generatedImgUrls.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    generatedImgUrls.length < 3 ? 1 : 3,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 0,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ImageDetailsModal(
                                          selectedImageUrl:
                                              generatedImgUrls[index],
                                          selectedImageMeta:
                                              generatedImagesMeta,
                                        );
                                      },
                                    );
                                    setState(() {});
                                  },
                                  child: FadeInImage(
                                    placeholder: AssetImage(
                                        'assets/images/tmp_image.png'),
                                    image:
                                        NetworkImage(generatedImgUrls[index]),
                                  ),
                                );
                              },
                            );
                          }
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
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kButtonLightPurple,
                      // gradient: LinearGradient(colors: [
                      //   Color.fromARGB(255, 61, 2, 50),
                      //   Color.fromARGB(255, 10, 6, 20)
                      // ])
                    ),
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
                                user.imagesToGenerate =
                                    (user.batchSizeSliderValue.toInt()),
                                generateImage(),
                                // _showInterstitialAd()
                                // _showRewardedAd()
                                _showRewardedInterstitialAd()
                              }
                            : showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Please Login"),
                                    content: Text(
                                        "Please Login to use this feature"),
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
                  showUpload
                      ? Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kButtonLightPurple,
                          ),
                          child: uploading
                              ? SpinKitThreeBounce(color: kWhite)
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: Text('Upload'),
                                  onPressed: () async {
                                    if (user.user!.isAnonymous) {
                                      user.showLogin(
                                          context, Map<String, dynamic>());
                                      return;
                                    }
                                    setState(() {
                                      uploading = true;
                                    });
                                    String? url =
                                        await uploadFile(context, storage);

                                    // Check if the upload was successful
                                    if (url != null) {
                                      setState(() {
                                        uploadImg2ImgImages.add(url);
                                        _selectedImageUrls!.add(url);
                                        print(_selectedImages);
                                        _selectedImages!.add({'img2img': url});
                                      });
                                    }
                                    setState(() {
                                      uploading = false;
                                    });
                                  },
                                ),
                        )
                      : Text(''),
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
                          // onPrimary: Colors.black,
                          shape: CircleBorder()),
                    ),
                  ),
                  Expanded(
                    child: Text(''),
                  ),
                ],
              ),
              if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
                Container(
                  width: bannerAd!.size.width.toDouble(),
                  height: bannerAd!.size.height.toDouble(),
                  child: _buildBannerAdWidget(),
                )
              else
                SizedBox(height: kDefaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
