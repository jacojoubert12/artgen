import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class AboutCenterView extends StatefulWidget {
  const AboutCenterView({Key? key, this.setViewMode}) : super(key: key);
  final Function? setViewMode;

  @override
  _AboutCenterViewState createState() => _AboutCenterViewState();
}

class _AboutCenterViewState extends State<AboutCenterView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _backgroundImage =
      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
              title: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      child: Text(
                        "About",
                        style: TextStyle(
                          fontFamily:
                              'custom font', // remove this if don't have custom font
                          fontSize: 20.0, // text size
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  // if (Responsive.isDesktop(context))
                  // Container(
                  //   child: Container(
                  //     margin: EdgeInsets.only(left: 20),
                  //     width: 45,
                  //     height: 45,
                  //     child: CircleAvatar(
                  //         backgroundImage: NetworkImage(_avatarImage)),
                  //   ),
                  // ),
                  SizedBox(width: 5),
                ],
              ),
              backgroundColor: kButtonLightPurple,
            )
          : null,
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(setViewMode: widget.setViewMode),
      ),
      body: Container(
        padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        color: kBgDarkColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              // This is our Seearch bar
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              //   child: Row(
              //     children: [
              //       // Once user click the menu icon the menu shows like drawer
              //       // Also we want to hide this menu icon on desktop
              //       if (!Responsive.isDesktop(context))
              //         IconButton(
              //           icon: Icon(
              //             Icons.menu,
              //             color: kButtonLightPurple,
              //           ),
              //           onPressed: () {
              //             _scaffoldKey.currentState!.openDrawer();
              //           },
              //         ),
              //       if (!Responsive.isDesktop(context)) SizedBox(width: 5),
              //     ],
              //   ),
              // ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    // Background image
                    Container(
                      height: 200,
                      width: double.maxFinite,
                      color: Color.fromARGB(0, 0, 0, 0),
                      child: Image.network(_backgroundImage, fit: BoxFit.cover),
                    ),
                    SizedBox(height: kDefaultPadding),
                    Text(
                      "About Us",
                      style: TextStyle(
                        fontFamily:
                            'custom font', // remove this if don't have custom font
                        fontSize: 20.0, // text size
                        color: kTextColorLightGrey, // text color
                      ),
                    ),
                    Text(
                      "About Us",
                      style: TextStyle(
                        fontFamily:
                            'custom font', // remove this if don't have custom font
                        fontSize: 15.0, // text size
                        color: kTextColorLightGrey, // text color
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                    Text(
                      "Contact Us",
                      style: TextStyle(
                        fontFamily:
                            'custom font', // remove this if don't have custom font
                        fontSize: 20.0, // text size
                        color: kTextColorLightGrey, // text color
                      ),
                    ),
                    Text(
                      "About Us",
                      style: TextStyle(
                        fontFamily:
                            'custom font', // remove this if don't have custom font
                        fontSize: 15.0, // text size
                        color: kTextColorLightGrey, // text color
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
