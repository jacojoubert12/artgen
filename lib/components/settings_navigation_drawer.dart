import 'package:artgen/constants.dart';
import 'package:artgen/responsive.dart';
import 'package:artgen/views/main_detail_views/createimg_detail_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../views/main/main_view.dart';
import '../views/main_detail_views/subscription_view.dart';

class SettingNavigationDrawer extends StatefulWidget {
  @override
  State<SettingNavigationDrawer> createState() =>
      _SettingNavigationDrawerState();
}

class _SettingNavigationDrawerState extends State<SettingNavigationDrawer> {
  _SettingNavigationDrawerState() {
    getModels();
  }

  String dropdownValue = "";
  List<String> modelList = [];

  void getModels() async {
    modelList = await getUniqueCheckpointFiles();
    print(modelList);
  }

  // Stream<List<Model >> readActiveWorkers() =>
  //     FirebaseFirestore.instance.collection('active_workers')
  //     .snapshots()
  //     .map((snapshot) => snapshot.docs.map((doc) =>ActiveWorkers.fromJason(doc.data())) .toList());

  Future<List<String>> getUniqueCheckpointFiles() async {
    final firestore = FirebaseFirestore.instance;
    final workersCollection = firestore.collection('active_workers');
    final snapshot = await workersCollection.get();
    final uniqueCheckpointFiles = <String>{};
    print("GET VALUESSS");
    for (var worker in snapshot.docs) {
      print(worker);
      final checkpointFile = worker.data()['checkpoint_file'];
      uniqueCheckpointFiles.add(checkpointFile);
    }
    return uniqueCheckpointFiles.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Responsive.isDesktop(context)
            ? MediaQuery.of(context).size.width * 0.6
            : MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: BoxDecoration(
            color: kBgDarkColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: kDefaultPadding),
            Text("Sampling Steps"),
            Slider(
              value: user.samplingStepsSliderValue,
              max: 150,
              min: 1,
              divisions: 149,
              label: user.samplingStepsSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  user.samplingStepsSliderValue = value;
                });
              },
            ),
            // SizedBox(height: kDefaultPadding),
            Text("Resolution"),
            Slider(
              value: user.resolutionSliderValue,
              max: 150,
              min: 1,
              divisions: 149,
              label: user.resolutionSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  user.resolutionSliderValue = value;
                });
              },
            ),
            // SizedBox(height: kDefaultPadding),
            Text("Width"),
            Slider(
              value: user.widthliderValue,
              max: 2048,
              min: 64,
              divisions: 1984,
              label: user.widthliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  user.widthliderValue = value;
                });
              },
            ),
            // SizedBox(height: kDefaultPadding),
            Text("Height"),
            Slider(
              value: user.heightSliderValue,
              max: 2048,
              min: 64,
              divisions: 1984,
              label: user.heightSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  user.heightSliderValue = value;
                });
              },
            ),
            // SizedBox(height: kDefaultPadding),
            Text("Guidance Scale"),
            Slider(
              value: user.guidanceScaleSliderValue,
              max: 30,
              min: 1,
              divisions: 29,
              label: user.guidanceScaleSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  user.guidanceScaleSliderValue = value;
                });
              },
            ),
            // SizedBox(height: kDefaultPadding),
            Text("Number of Images"),
            Slider(
              value: user.batchSizeSliderValue,
              max: 100,
              min: 1,
              divisions: 99,
              label: user.batchSizeSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  user.batchSizeSliderValue = value;
                });
              },
            ),

            //Dropdown
            SizedBox(height: kDefaultPadding),
            Container(
              child: Container(
                // padding: EdgeInsets.only(left: 30, right: 30),
                child: DecoratedBox(
                  decoration: BoxDecoration(

                      // color: Color.fromARGB(44, 215, 4, 170),
                      ),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    borderRadius: BorderRadius.circular(20),
                    itemHeight: 50,
                    items:
                        modelList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ),

            SizedBox(height: kDefaultPadding),

            //Save Button
            Container(
              height: 30.0,
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 61, 2, 50),
                    Color.fromARGB(255, 10, 6, 20)
                  ])),
              child: ElevatedButton(
                onPressed: () {
                  //save profile
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CreateImgDetailView();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
