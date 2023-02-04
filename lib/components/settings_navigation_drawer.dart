import 'package:artgen/constants.dart';
import 'package:artgen/responsive.dart';
import 'package:artgen/views/main_detail_views/createimg_detail_view.dart';
import 'package:flutter/material.dart';

import '../views/main/main_view.dart';
import '../views/main_detail_views/subscription_view.dart';

class SettingNavigationDrawer extends StatefulWidget {
  @override
  State<SettingNavigationDrawer> createState() =>
      _SettingNavigationDrawerState();
}

class _SettingNavigationDrawerState extends State<SettingNavigationDrawer> {
  String dropdownValue = 'Dog';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Responsive.isDesktop(context)
            ? MediaQuery.of(context).size.width * 0.6
            : MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: BoxDecoration(
            color: Colors.white,
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
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(44, 215, 4, 170),
                  ),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    borderRadius: BorderRadius.circular(20),
                    itemHeight: 50,
                    items: <String>['Dog', 'Cat', 'Tiger', 'Lion']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 30),
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
            SizedBox(
              height: 30.0,
              width: 250,
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
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
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
