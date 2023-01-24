import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:artgen/responsive.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import '../constants.dart';
import '../extensions.dart';
import 'side_menu_item.dart';
import 'tags.dart';

class SettingNavigationDrawer extends StatelessWidget {
  const SettingNavigationDrawer({Key key, this.setViewMode}) : super(key: key);
  final Function setViewMode;

  // double _samplingStepsSliderValue = 20;
  // double _resolutionSliderValue = 20;
  // double _widthliderValue = 512;
  // double _heightSliderValue = 512;
  // double _guidanceScaleSliderValue = 15;
  // // double _batchCountSliderValue = 1;
  // double _batchSizeSliderValue = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      // padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
      color: kBgLightColor,
      child: SafeArea(
        child: SingleChildScrollView(
          // padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              Image.asset(
                "assets/images/flower.png",
                // width: 46,
                fit: BoxFit.fill,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: kDefaultPadding * 6),
                  // Avatar Image
                  Positioned(
                    // top: MediaQuery.of(context).size.height / 8,
                    // left: MediaQuery.of(context).size.width / 2 - 50,
                    child: Container(
                      width: 100,
                      height: 100,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg'),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "User Name",
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 20.0, // text size
                  color: Colors.black, // text color
                ),
              ),
              Text(
                "User Plan",
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 10.0, // text size
                  color: Colors.black, // text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
