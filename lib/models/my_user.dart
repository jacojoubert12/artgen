import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:artgen/auth_gate.dart';
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
  int images_generated = 0;
  int activePackage = 0;
  List<DocumentSnapshot> packages = [];
  Map<String, dynamic> user_info = {};
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

  Future<String?> getStrData(String key) async {
    if (kIsWeb) {
      return _localStorage[key];
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
      return _localStorage[key] as int;
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(key);
    }
  }

  Future<void> storeIntData(String key, int? value) async {
    if (kIsWeb) {
      _localStorage[key] = (value as String);
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(key, value!);
    }
  }

  getPackages() async {
    Map<int, dynamic> packageMap = {};
    packages = await getDocumentsFromCollection("packages");
    // print(packages);
    packages.forEach((element) {
      var package = element.data() as Map<String, dynamic>;
      packageMap[package['id']] = package;
      // print(package);
    });

    if (images_generated > packageMap[0]['img_limit'] &&
        activePackage == packageMap[0]['id'] &&
        user!.isAnonymous) {
      FirebaseAuth.instance.signOut();
      shouldLogin = true;
    } else if (images_generated > packageMap[1]['img_limit'] &&
        activePackage == packageMap[1]['id']) {
      shouldShowPackages = true;
    } else if (images_generated > packageMap[2]['img_limit'] &&
        activePackage == packageMap[2]['id']) {
      shouldShowPackages = true;
    } else if (images_generated > packageMap[3]['img_limit'] &&
        activePackage == packageMap[3]['id']) {
      shouldShowPackages = true;
    } else if (images_generated > packageMap[4]['img_limit'] &&
        activePackage == packageMap[4]['id']) {
      shouldShowPackages = true;
    }
  }

  void getCurrentPackage() async {
    // DocumentReference<Map<String, dynamic>> user_info_doc =
    // await getSingleDocRefFromCollection("users", user!.uid);
    // CollectionReference users = FirebaseFirestore.instance.collection('users');
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(user!.uid)
    //     .get()
    //     .then((DocumentSnapshot documentSnapshot) {
    //   if (documentSnapshot.exists) {
    //     print('Document exists on the database');
    //   }
    // });

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        user_info = documentSnapshot.data() as Map<String, dynamic>;
        // print('Document data: ${documentSnapshot.data()}');
        print(user_info['package']);
        activePackage = user_info["package"];
      } else {
        activePackage = 0;
        documentSnapshot.reference.set({"package": 0});
        // print('Document does not exist on the database');
      }
    });
  }

  void guestLogin() async {
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Sign in anonymously
      FirebaseAuth.instance.signInAnonymously().then((userCredentials) async {
        activePackage = 0;
        user = userCredentials.user;
        app_id = await getStrData("app_id");
        int? stored_images_generated = (await getIntData("images_generated"));
        if (app_id == null || stored_images_generated == null) {
          app_id = user?.uid;
          storeStrData("app_id", app_id);
          storeIntData("images_generated", 0);
          print("app_id");
          print(app_id);
        } else {
          images_generated = stored_images_generated;
        }
      });
    }
    if (user != null) {
      getPackages();
      if (!user!.isAnonymous) {
        print("NOT ANONaMOUSES");
        getCurrentPackage();
      } else {
        print("ANONaMOUSES");
      }
    }
  }

  Future<void> showLogin(BuildContext context) async {
    (shouldLogin && images_generated > 5)
        ? showDialog(
            context: context,
            builder: (BuildContext context) {
              return AuthGate();
            },
          )
        : null;
  }

  // void guestLogin() async {
  //   user?.app_id = await getStrData("app_id");
  //   user?.images_generated = (await getIntData("images_generated")) as int?;
  //   if (user?.app_id == null) {
  //     user?.user = FirebaseAuth.instance.currentUser;
  //     if (user?.user == null) {
  //       // Sign in anonymously
  //       FirebaseAuth.instance.signInAnonymously().then((userCredentials) {
  //         user?.user = userCredentials.user;
  //         user?.app_id = user!.user?.uid;
  //         storeStrData("app_id", user?.app_id);
  //         storeIntData("images_generated", 0);
  //       });
  //     }
  //   } else {
  //     if (user!.images_generated! > 5) {
  //       FirebaseAuth.instance.signOut();
  //     }
  //   }
  // }
}
