import 'package:artgen/constants.dart';
import 'package:artgen/responsive.dart';
import 'package:artgen/views/main_detail_views/createimg_detail_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';

import '../views/main/main_view.dart';
import '../views/main_detail_views/subscription_view.dart';

class SettingNavigationDrawer extends StatefulWidget {
  SettingNavigationDrawer(
      {Key? key,
      this.setViewMode,
      this.selectedImages,
      this.selectedImageUrls,
      this.updateSelectedImages,
      this.showDetailView})
      : super(key: key);
  final Function? setViewMode;
  final Function? updateSelectedImages;
  final Function? showDetailView;
  final selectedImages;
  final selectedImageUrls;
  List<String> imageUrls = [];
  List<dynamic> images = [];

  @override
  State<SettingNavigationDrawer> createState() =>
      _SettingNavigationDrawerState();
}

class _SettingNavigationDrawerState extends State<SettingNavigationDrawer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String dropdownValue = '';
  List<String> modelList = [];

  Future<List<String>> getUniqueCheckpointFiles() async {
    Set<String> uniqueFiles = Set();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("active_workers").get();
    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      data.forEach((key, value) {
        uniqueFiles.add(value["checkpoint_file"]);
      });
    });
    modelList = uniqueFiles.toList();
    dropdownValue == ''
        ? dropdownValue = modelList[0]
        : dropdownValue = dropdownValue;
    return modelList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        // alignment: Alignment.center,
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
            Container(
              // height: 35.0,
              // width: 50,
              child: Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  child: Icon(
                    Icons.arrow_back,
                    size: 30.0,
                    color: kButtonLightPurple,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(0, 181, 9, 129),
                      onPrimary: Colors.black,
                      shape: CircleBorder()),
                ),
              ),
            ),
            // SizedBox(),

            SizedBox(height: kDefaultPadding),

            // Container(),
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
              // height: 40,
              child: FutureBuilder(
                future: getUniqueCheckpointFiles(),
                builder: (context, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      // padding: EdgeInsets.only(left: 30, right: 30),
                      child: DecoratedBox(
                        decoration: BoxDecoration(

                            // color: Color.fromARGB(44, 215, 4, 170),
                            ),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          borderRadius: BorderRadius.circular(20),
                          itemHeight: 50,
                          items: modelList
                              .map<DropdownMenuItem<String>>((String value) {
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
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
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
              //Save Button
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
        // ),
      ),
    );
  }
}
