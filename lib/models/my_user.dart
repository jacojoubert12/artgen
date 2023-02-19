import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:artgen/auth_gate.dart';
import 'package:artgen/responsive.dart';
import 'package:artgen/views/main_detail_views/subscription_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/auth.dart';
// import 'package:firebase_firestore/firebase_firestore.dart';

class MyUser {
  User? user;
  String? app_id;
  bool shouldLogin = true;
  bool shouldShowPackages = false;
  bool shouldGetPackages = true;
  bool shouldGetCurrentPackage = true;
  int imagesGenerated = 2;
  int imagesToGenerate = 0;
  int activePackage = 0;
  int imageLimit = 500;
  String pubTopic = "mdjrny_v4";
  Map<int, dynamic> packageMap = {};
  Map<String, dynamic> userInfo = {};
  final Storage _localStorage = window.localStorage;
  List<String> modelList = [];
  String selectedModel = '';
  String subTopic = '';
  List<double> widths = [768, 704, 640, 576, 512, 460, 512, 512, 512, 512];
  List<double> heights = [512, 512, 512, 512, 512, 460, 576, 640, 704, 768];

  //ImgGen Settings
  double samplingStepsSliderValue = 20;
  double resolutionSteps = 10;
  double resolutionSliderValue = 0;
  double widthSliderValue = 512;
  double heightSliderValue = 512;
  double guidanceScaleSliderValue = 15;
  // double batchCountSliderValue = 1;
  double batchSizeSliderValue = 1;

  MyUser() {}

  initMyUser() {
    guestLogin();
    getUniqueCheckpointFiles();
    setSubTopic();
  }

  setSubTopic() {
    subTopic = "img_gen_response/" + user!.uid;
  }

  Future<List<DocumentSnapshot>> getDocumentsFromCollection(
      String collectionName) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    return documents;
  }

  Future<DocumentSnapshot> getSingleDocumentFromCollection(
      String collectionName, String documentId) async {
    var documentReference =
        FirebaseFirestore.instance.collection(collectionName).doc(documentId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot;
  }

  void getIntValueFromDoc(String collectionName, String documentId,
      String field, dynamic varToSet) async {
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentId)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        var value = (documentSnapshot.data() as Map<String, dynamic>)[field];
        varToSet = value;
      } else {
        print("Value not found!!!");
        return 0;
      }
    });
  }

  Future<List<String>> getUniqueCheckpointFiles() async {
    Set<String> uniqueFiles = Set();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("active_workers").get();
    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      var dateUtc = DateTime.now().toUtc();
      data.forEach((key, value) {
        var now = Timestamp.fromDate(dateUtc);
        Timestamp activeTime = value['active'];
        if ((now.seconds - activeTime.seconds) < 1000)
          uniqueFiles.add(value["checkpoint_file"]);
      });
    });
    modelList = uniqueFiles.toList();
    modelList.length == 0
        ? {modelList.add("no available models"), selectedModel = modelList[0]}
        : selectedModel == ''
            ? selectedModel = modelList[0]
            : selectedModel = selectedModel;
    modelList.insert(0, '*');
    return modelList;
  }

  Future<DocumentReference<Map<String, dynamic>>> getSingleDocRefFromCollection(
      String collectionName, String documentId) async {
    var documentReference =
        FirebaseFirestore.instance.collection(collectionName).doc(documentId);
    return documentReference;
  }

  void writeToCollection(
      String collectionName, Map<String, dynamic> data) async {
    var collectionReference =
        FirebaseFirestore.instance.collection(collectionName);
    await collectionReference.add(data);
  }

  void updateDocument(String collectionName, String documentId,
      String fieldName, dynamic value) {
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentId)
        .update({
      fieldName: value,
    });
  }

  Future<void> incrementValue(
      String collection, String documentId, String field, int value) async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection(collection).doc(documentId);
    await ref.update({field: FieldValue.increment(value)});
  }

  Future<String?> getStrData(String key) async {
    if (kIsWeb) {
      String? value = _localStorage[key];
      return value;
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
  }

  Future<void> storeStrData(String key, String? value) async {
    if (kIsWeb) {
      _localStorage[key] = value!;
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(key, value!);
    }
  }

  Future<int?> getIntData(String key) async {
    if (kIsWeb) {
      print("Nulll yet?");
      String? strValue = _localStorage[key];
      if (strValue == null) {
        return 0;
      }
      int? value;
      try {
        value = int.tryParse(strValue);
      } catch (_) {
        value = 0;
      }
      print("getIntData");
      print(value);
      return value;
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(key) ?? 0;
    }
  }

  Future<void> storeIntData(String key, int? value) async {
    if (kIsWeb) {
      print("storeIntData");
      print(value);
      _localStorage[key] = value.toString();
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(key, value!);
    }
  }

  updateImagesGenerated() {
    print("updateImagesGenerated");
    imagesGenerated += imagesToGenerate;
    imagesToGenerate = 0;
    !user!.isAnonymous
        ? incrementValue(
            "users", user!.uid, "images_generated", imagesToGenerate)
        : print("User anonamous");
  }

  getPackages() async {
    var packages = await getDocumentsFromCollection("packages");
    // print(packages);
    packages.forEach((element) {
      var package = element.data() as Map<String, dynamic>;
      packageMap[package['id']] = package;
      print(package);
    });
    shouldGetPackages = false;
  }

  Future<void> packageCheck() async {
    var tmpImageLimit = imageLimit - 2;
    if (imagesGenerated > tmpImageLimit &&
        activePackage == packageMap[0]['id'] &&
        user!.isAnonymous) {
      FirebaseAuth.instance.signOut();
      shouldLogin = true;
      // shouldShowPackages = false;
    } else if (imagesGenerated > tmpImageLimit) {
      shouldLogin = false;
      shouldShowPackages = true;
    } else {
      shouldLogin = false;
      shouldShowPackages = false;

      storeIntData("images_generated", imagesGenerated);
      //only update every 5 images... does this save firebase writes? TODO How much does it cost?
      // imagesGenerated % 5 == 0 ?
      updateImagesGenerated();
      getIntValueFromDoc(
          'users', user!.uid, 'images_generated', imagesGenerated);
      // : print("will update later");
    }
    print("In packageCheck: imagesGenerated:");
    print(imagesGenerated);
  }

  void logImgGenRequest(Map<String, dynamic> query) {
    writeToCollection("image_gen_queries", query);
  }

  void getCurrentPackage() async {
    if (user == null) return;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        userInfo = documentSnapshot.data() as Map<String, dynamic>;
        // print('Document data: ${documentSnapshot.data()}');
        print("userInfo");
        print(userInfo);
        print("userInfo['package']");
        print(userInfo['package']);
        activePackage = userInfo['package'];
        imageLimit = packageMap[activePackage]['img_limit'];
        imagesGenerated = userInfo['images_generated'];
        print("activePackage");
        print(activePackage);
        print("packageMap[activePackage]['img_limit']");
        print(packageMap[activePackage]['img_limit']);
        print("app_id");
        print(app_id);
        print("imageLimit");
        print(imageLimit);
        print("imagesGenerated");
        print(imagesGenerated);
        print("uuid");
        print(user?.uid);
      } else {
        activePackage = 0;
        !user!.isAnonymous
            ? documentSnapshot.reference.set({'package': 1})
            : print("Anonamous user");
        // print('Document does not exist on the database');
      }
    });
    shouldGetCurrentPackage = false;
  }

  void guestLogin() async {
    user = FirebaseAuth.instance.currentUser;
    getPackages();
    getCurrentPackage();
    if (user == null) {
      // Sign in anonymously
      FirebaseAuth.instance.signInAnonymously().then((userCredentials) async {
        activePackage = 0;
        user = userCredentials.user;
        var appIdTmp = await getStrData("app_id");
        if (appIdTmp == null) {
          storeStrData("app_id", user!.uid);
          app_id = user!.uid;
        }
        var generatedImgsTmp = await getIntData("images_generated");
        if (generatedImgsTmp == null) {
          print("generatedImgsTmp == null");
          storeIntData("images_generated", imagesGenerated);
        } else {
          imagesGenerated = generatedImgsTmp;
          print("generatedImgsTmp not null");
        }
      });
    }
    if (user != null) {
      if (!user!.isAnonymous) {
        print("NOT ANONaMOUSES");
        shouldLogin = false;
      } else {
        var appIdTmp = await getStrData("app_id");
        if (appIdTmp == null) {
          storeStrData("app_id", user!.uid);
          app_id = user!.uid;
        }
        var generatedImgsTmp = await getIntData("images_generated");
        if (generatedImgsTmp == null) {
          print("generatedImgsTmp == null");
          storeIntData("images_generated", imagesGenerated);
        } else {
          imagesGenerated = generatedImgsTmp;
          print("generatedImgsTmp not null");
        }
        print("ANONaMOUSES");
        print("appIdTmp");
        print(appIdTmp);
        appIdTmp = await getStrData("app_id");
        print("appIdTmp Now?");
        print(appIdTmp);
        print(user!.uid);
        print("images_generated");
        print(imagesGenerated);
      }
    }
  }

  bool showLogin(BuildContext context, Map<String, dynamic> query) {
    shouldGetPackages ? getPackages() : print('Already got packages?');
    // shouldGetCurrentPackage //Optimise later
    // ? getCurrentPackage()
    // : print("Already got current package?");
    getCurrentPackage();
    packageCheck();
    print("imagesGenerated");
    print(imagesGenerated);
    print("imageLimit");
    print(imageLimit);
    print("ShouldLogin");
    print(shouldLogin);
    print("app_id");
    print(app_id);

    if (shouldLogin) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AuthGate();
        },
      );
      shouldGetCurrentPackage = true;
      shouldGetPackages = true;
      return false;
    } else {
      print("user logged in");
    }
    if (shouldShowPackages) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SubscriptionView();
        },
      );
      return false;
    } else {
      logImgGenRequest(query);
      print("user packages still valid");
    }
    return true;
  }
}












//Futurebuilder Example

// Container(
//               // height: 40,
//               child: FutureBuilder(
//                 future: getUniqueCheckpointFiles(),
//                 builder: (context, AsyncSnapshot<List<String>> snapshot) {
//                   if (snapshot.hasData) {
//                     return Container(
//                       // padding: EdgeInsets.only(left: 30, right: 30),
//                       child: DecoratedBox(
//                         decoration: BoxDecoration(

//                             // color: Color.fromARGB(44, 215, 4, 170),
//                             ),
//                         child: DropdownButton<String>(
//                           value: user.selectedModel,
//                           borderRadius: BorderRadius.circular(20),
//                           itemHeight: 50,
//                           items: user.modelList
//                               .map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(
//                                 value,
//                                 style: TextStyle(fontSize: 20),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               user.selectedModel = newValue!;
//                               user.pubTopic = user.selectedModel;
//                             });
//                           },
//                         ),
//                       ),
//                     );
//                   } else {
//                     return CircularProgressIndicator();
//                   }
//                 },
//               ),
//             ),