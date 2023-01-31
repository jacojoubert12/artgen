import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:artgen/auth_gate.dart';
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
  int imagesGenerated = 0;
  int imagesToGenerate = 0;
  int activePackage = 0;
  int imageLimit = 5;
  Map<int, dynamic> packageMap = {};
  Map<String, dynamic> userInfo = {};
  final Storage _localStorage = window.localStorage;

  MyUser() {}

  initMyUser() {
    guestLogin();
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
      int? value = _localStorage[key] as int;
      return value;
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(key);
    }
  }

  Future<void> storeIntData(String key, int? value) async {
    if (kIsWeb) {
      _localStorage[key] = value.toString();
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(key, value!);
    }
  }

  updateImagesGenerated() {
    !user!.isAnonymous
        ? incrementValue(
            "users", user!.uid, "images_generated", imagesToGenerate)
        : print("User anonamous");
    imagesGenerated += imagesToGenerate;
    imagesToGenerate = 0;
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
    if (imagesGenerated > imageLimit &&
        activePackage == packageMap[0]['id'] &&
        user!.isAnonymous) {
      FirebaseAuth.instance.signOut();
      shouldLogin = true;
      // shouldShowPackages = false;
    } else if (imagesGenerated > imageLimit) {
      shouldLogin = false;
      shouldShowPackages = true;
    } else {
      shouldLogin = false;
      shouldShowPackages = false;
    }
    storeIntData("imagesGenerated", imagesGenerated);
    //only update every 5 images... does this save firebase writes? TODO How much does it cost?
    // imagesGenerated % 5 == 0 ?
    updateImagesGenerated();
    getIntValueFromDoc('users', user!.uid, 'images_generated', imagesGenerated);
    print("In packageCheck: imagesGenerated:");
    print(imagesGenerated);
    // : print("will update later");
  }

  void getCurrentPackage() async {
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
        app_id = await getStrData("app_id");
        int? stored_imagesGenerated = (await getIntData("imagesGenerated"));
        if (app_id == null || stored_imagesGenerated == null) {
          app_id = user?.uid;
          storeStrData("app_id", app_id);
          storeIntData("imagesGenerated", 0);
          print("app_id");
          print(app_id);
        } else {
          imagesGenerated = stored_imagesGenerated;
        }
      });
    }
    if (user != null) {
      if (!user!.isAnonymous) {
        print("NOT ANONaMOUSES");
        shouldLogin = false;
      } else {
        print("ANONaMOUSES");
      }
    }
  }

  Future<void> showLogin(BuildContext context) async {
    shouldGetPackages ? getPackages() : print('Already got packages?');
    shouldGetCurrentPackage
        ? getCurrentPackage()
        : print("Already got current package?");
    packageCheck();
    print("imagesGenerated");
    print(imagesGenerated);
    print("imageLimit");
    print(imageLimit);
    print("ShouldLogin");
    print(shouldLogin);

    shouldLogin
        ? {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AuthGate();
              },
            ),
            shouldGetCurrentPackage = true,
            shouldGetPackages = true
          }
        : print("user logged in");
    shouldShowPackages
        ? showDialog(
            context: context,
            builder: (BuildContext context) {
              return SubscriptionView();
            },
          )
        : print("user packages still valid");
  }
}
