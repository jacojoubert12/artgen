import 'package:flutter/material.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import 'side_menu_item.dart';

class SideMenu extends StatefulWidget {
  SideMenu({Key? key, this.setViewMode}) : super(key: key);

  final Function? setViewMode;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String userName = 'Welcome';
  String bannerImage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: kBgDarkColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                color: Color(0xFF),
                child: Image(
                  image: AssetImage('assets/images/flower.png'),
                ),
                // child: NetworkImage(bannerImage, fit: BoxFit.fitWidth),
              ),
              // Positioned(
              //   top: MediaQuery.of(context).size.height / 2,
              //   left: MediaQuery.of(context).size.width / 2 - 50,
              //   child: Container(
              //     width: 80,
              //     height: 80,
              //     child: CircleAvatar(
              //       // backgroundImage: NetworkImage(_avatarImage),
              //       child: NetworkImage("assets/images/flower.png"),
              //     ),
              //   ),
              // ),
              SizedBox(height: kDefaultPadding),
              Text(
                userName,
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 20.0, // text size
                  color: Color.fromARGB(255, 255, 255, 255), // text color
                ),
              ),
              SideMenuItem(
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 20.0, // text size
                  color: Color.fromARGB(255, 255, 255, 255), // text color
                ),
                press: () {
                  this.widget.setViewMode!(ViewMode.create);
                },
                title: "Create",
                icon: Icon(
                  Icons.create,
                  color: kButtonLightPurple,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 20.0, // text size
                  color: Color.fromARGB(255, 255, 255, 255), // text color
                ),
                press: () {
                  this.widget.setViewMode!(ViewMode.mygallery);
                },
                title: "My Gallery",
                icon: Icon(
                  Icons.collections,
                  color: kButtonLightPurple,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 20.0, // text size
                  color: Color.fromARGB(255, 255, 255, 255), // text color
                ),
                press: () {
                  this.widget.setViewMode!(ViewMode.explore);
                },
                title: "Explore",
                icon: Icon(
                  Icons.explore,
                  color: kButtonLightPurple,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 20.0, // text size
                  color: Color.fromARGB(255, 255, 255, 255), // text color
                ),
                press: () {
                  print(ViewMode.profile);
                  this.widget.setViewMode!(ViewMode.profile);
                },
                title: "Profile",
                icon: Icon(
                  Icons.face,
                  color: kButtonLightPurple,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 20.0, // text size
                  color: Color.fromARGB(255, 255, 255, 255), // text color
                ),
                press: () {
                  this.widget.setViewMode!(ViewMode.about);
                },
                title: "About",
                icon: Icon(
                  Icons.fingerprint,
                  color: kButtonLightPurple,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 20.0, // text size
                  color: Color.fromARGB(255, 255, 255, 255), // text color
                ),
                press: () {
                  Share.share('check out my website https://google.com');
                },
                title: "Share",
                icon: Icon(
                  Icons.share,
                  color: kButtonLightPurple,
                ),
                isActive: false,
                showBorder: true,
              ),
              SizedBox(height: kDefaultPadding),
              InkWell(
                onTap: () => launchUrl(Uri.parse('https://www.google.com')),
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                      decoration: TextDecoration.underline, color: Colors.blue),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(height: kDefaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
