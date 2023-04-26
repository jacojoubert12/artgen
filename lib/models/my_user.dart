import 'dart:async';
import 'package:artgen/auth_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'local_storage_access_mobile.dart'
    if (dart.library.html) 'local_storage_access_web.dart';

class MyUser extends ChangeNotifier {
  User? user;
  String accessToken = '';
  int age = 0;
  String? app_id;
  bool userInitDone = false;
  bool shouldLogin = true;
  bool shouldShowPackages = false;
  bool shouldGetPackages = true;
  bool shouldGetCurrentPackage = true;
  int imagesGenerated = 2;
  int imagesToGenerate = 0;
  int activePackage = 0;
  int imageLimit = 100; //0;
  String pubTopic = "mdjrny_v4";
  Map<int, dynamic> packageMap = {};
  Map<String, dynamic> userInfo = {};
  List<String> modelList = [];
  String selectedModel = '';
  String subTopic = "img-gen-res";
  String searchSubTopic = "keyword-search-res";
  String featuredSubTopic = "featured-search-res";
  String gallerySubTopic = "gallery-search-res";
  List<double> widths = [768, 704, 640, 576, 512, 460, 512, 512, 512, 512];
  List<double> heights = [512, 512, 512, 512, 512, 460, 576, 640, 704, 768];
  List<String> admins = [];

  //ImgGen Settings
  double samplingStepsSliderValue = 50;
  double resolutionSteps = 10;
  double resolutionSliderValue = 9;
  double widthSliderValue = 512;
  double heightSliderValue = 768;
  double guidanceScaleSliderValue = 15;
  double denoisingStrengthSliderValue = 0.5;
  // double batchCountSliderValue = 1;
  double batchSizeSliderValue = 1;

  double nsfwFilterSliderValue = 0.2;

  MyUser() {
    // initMyUser();
  }

  initMyUser() async {
    await guestLogin();
    getUniqueCheckpointFiles();
    setSubTopicAsync().then((_) => userInitDone = true);
    getAdminUsers();
  }

  void getAdminUsers() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('admins');
    QuerySnapshot querySnapshot = await collectionRef.get();
    for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
      String name = docSnapshot.id;
      admins.add(name);
    }
  }

  Future<void> get loggedInUserFuture {
    final completer = Completer<void>();
    print("Going to check if user is logged in...");

    void checkUser() {
      if (user != null) {
        print("User logged in...");
        completer.complete();
        removeListener(checkUser);
      } else {
        print("checkUser: Not logged in yet");
      }
    }

    // Check if the user is already logged in before adding the listener
    if (user != null) {
      print("User logged in...");
      completer.complete();
    } else {
      addListener(checkUser);
    }

    return completer.future;
  }

  Future<void> get loggedInUserFutureForImgGen {
    final completer = Completer<void>();
    print("Going to check if user is logged in...");

    void checkUser() {
      if (user != null) {
        print("User logged in...");
        completer.complete();
        removeListener(checkUser);
      }
    }

    // Check if the user is already logged in before adding the listener
    if (user != null) {
      print("User logged in...");
      completer.complete();
    } else {
      addListener(checkUser);
    }

    return completer.future;
  }

  Future<void> get haveCheckpointFiles {
    final completer = Completer<void>();
    print("Going to check if modelList has been updated...");

    void checkCheckpointFiles() {
      if (modelList.length > 0) {
        print("Available models loaded...");
        completer.complete();
        removeListener(checkCheckpointFiles);
      }
    }

    if (modelList.length > 0) {
      print("Available models loaded...");
      completer.complete();
    } else {
      addListener(checkCheckpointFiles);
    }

    return completer.future;
  }

  Future<void> setSubTopicAsync() async {
    while (user == null) {
      // Wait until user is not null
      await Future.delayed(Duration(milliseconds: 5000));
      if (user == null) guestLogin();
    }
    //Do everything that requires a UID after this
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
    print("Updating list of available models");
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
    print("modelList:");
    print(modelList);
    modelList.length == 0
        ? {modelList.add("*"), selectedModel = modelList[0]}
        : selectedModel == ''
            ? selectedModel = modelList[0]
            : selectedModel = selectedModel;
    if (!modelList.contains('*')) modelList.insert(0, '*');
    notifyListeners();
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

  Future<void> getCurrentPackage() async {
    if (user == null) return;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        userInfo = documentSnapshot.data() as Map<String, dynamic>;
        print("userInfo");
        print(userInfo);
        print("userInfo['package']");
        print(userInfo['package']);
        activePackage = userInfo['package'];
        imageLimit = packageMap[activePackage]['img_limit'];
        imagesGenerated = userInfo['images_generated'];
        age = userInfo['age'];
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
            ? documentSnapshot.reference.set({'package': 1, 'age': age})
            : print("Anonamous user");
        // print('Document does not exist on the database');
      }
    });
    shouldGetCurrentPackage = false;
  }

  Future<void> guestLogin() async {
    user = FirebaseAuth.instance.currentUser;
    print("guestLogin");

    if (user == null) {
      print("user is null in guestLogin");
      // Sign in anonymously
      UserCredential userCredentials =
          await FirebaseAuth.instance.signInAnonymously();
      user = userCredentials.user;
    }

    if (user != null) {
      await getPackages();
      await getCurrentPackage();

      if (!user!.isAnonymous) {
        print("User NOT Anonymous");
        shouldLogin = false;
      } else {
        print("Anonymous");
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
        print("appIdTmp:");
        print(appIdTmp);
        print("images_generated");
        print(imagesGenerated);
      }
    }
  }

  bool showLogin(BuildContext context, Map<String, dynamic> query) {
    shouldGetPackages ? getPackages() : print('Already got packages');
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
    // if (shouldShowPackages) {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return SubscriptionView();
    //     },
    //   );
    //   return false;
    // } else {
    //   logImgGenRequest(query);
    //   print("user packages still valid");
    // }
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
//                     return SpinKitThreeBounce(color: Colors.pink)();
//                   }
//                 },
//               ),
//             ),