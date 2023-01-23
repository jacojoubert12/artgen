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
// import 'dream_journal.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

// final ButtonStyle flatButtonStyle = TextButton.styleFrom(
//   primary: kPrimaryColor,
//   minimumSize: const Size(88, 36),
//   padding: EdgeInsets.symmetric(horizontal: 16.0),
//   shape: const RoundedRectangleBorder(
//     borderRadius: BorderRadius.all(Radius.circular(10)),
//   ),
// );

class SideMenu extends StatelessWidget {
  const SideMenu({Key key, this.setViewMode}) : super(key: key);

  final Function setViewMode;

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
              // Menu Items
              SideMenuItem(
                press: () {
                  this.setViewMode(ViewMode.create);
                },
                title: "Create",
                icon: Icon(
                  Icons.create,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode(ViewMode.mygallary);
                },
                title: "My Gallary",
                icon: Icon(
                  Icons.collections,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode(ViewMode.explore);
                },
                title: "Explore",
                icon: Icon(
                  Icons.explore,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode(ViewMode.likes);
                },
                title: "Likes",
                icon: Icon(
                  Icons.favorite,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode(ViewMode.profile);
                },
                title: "Profile",
                icon: Icon(
                  Icons.face,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  this.setViewMode(ViewMode.about);
                },
                title: "About",
                icon: Icon(
                  Icons.fingerprint,
                ),
                isActive: false,
                showBorder: true,
              ),
              SideMenuItem(
                press: () {
                  Share.share('check out my website https://google.com');
                },
                title: "Share",
                icon: Icon(
                  Icons.share,
                ),
                isActive: false,
                showBorder: true,
              ),

              SizedBox(height: kDefaultPadding),
              SignOutButton(),
              SizedBox(height: kDefaultPadding),

              // SizedBox(height: kDefaultPadding * 2),
              // Tags
              // Tags(),
            ],
          ),
        ),
      ),
    );
  }
}
