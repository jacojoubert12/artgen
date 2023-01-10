import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:artgen/models/mood.dart';
import 'package:artgen/auth_gate.dart';

class FireStoreManager {
  FireStoreManager();

  //Can make normal Future/get
  Stream<List<Mood>> getDefaultMoods() => FirebaseFirestore.instance
      .collection("default_moods")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Mood.fromJson(doc.data())).toList());

  Stream<List<Mood>> getUserMoods() => FirebaseFirestore.instance
      .collection("user_moods")
      .where('uid', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) => Mood.moodListFromJson(snapshot));

  StreamBuilder<List<Mood>> initUserMoods(listView) {
    return StreamBuilder<List<Mood>>(
        stream: getUserMoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("waiting");
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            print("That was the error");
            initDefaultMoods(listView);
          } else if (snapshot.hasData) {
            print("defaultMoods snapshot.hasData");
            if (snapshot.data.length > 0) moods = snapshot.data;
            if (moods.length == 0) {
              return initDefaultMoods(listView);
            } else {
              return listView;
            }
          }
          return moods.length == 0
              ? CircularProgressIndicator(color: Colors.red)
              : listView;
        });
  }

  StreamBuilder<List<Mood>> initDefaultMoods(listView) {
    print("initDefaultMoods:");
    return StreamBuilder<List<Mood>>(
        stream: getDefaultMoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("default waiting");
          }
          if (snapshot.hasError) {
            print("getdefaultmoods snapshot error");
            print(snapshot.error);
            return CircularProgressIndicator(color: Colors.yellowAccent);
          } else if (snapshot.hasData) {
            print("getDefaultMoods snapshot.hasData");
            if (snapshot.data.length > 0) moods = snapshot.data;
            print("snapshot:");
            print(snapshot.data);
            print("default moods:");
            print(moods);
            print("default moods len:");
            print(moods.length);
            if (moods.length == 0) {
              print("Error, should receive list of default moods");
            } else {
              print("going to instertDefaultMoods");
              insertDefaultMoods();
            }
          }
          return moods.length == 0
              ? CircularProgressIndicator(color: Colors.red)
              : listView;
        });
  }

  Future insertDefaultMoods() async {
    final userMoods =
        FirebaseFirestore.instance.collection("user_moods").doc(user.uid);
    List<Map<String, dynamic>> jsonMoods = [];
    for (var mood in moods) {
      jsonMoods.add(mood.toJson());
    }
    print(jsonMoods);
    await userMoods.set({'uid': user.uid, 'moods': jsonMoods});
  }

  // Future isUserDefaultsSet() async {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((element) {
  //       print(element.id);
  //       print(element);
  //       if (element.data().isEmpty) userDefaultsSet();
  //     });
  //   });
  // }

  // Future userDefaultsSet() async {
  //   final userDefaults =
  //       FirebaseFirestore.instance.collection("users").doc(user.uid);
  //   userDefaults.set({"defaults_set": true});
  // }
}
