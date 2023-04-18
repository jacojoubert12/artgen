import 'package:artgen/components/rounded_button.dart';
import 'package:artgen/constants.dart';
import 'package:artgen/responsive.dart';
import 'package:artgen/views/main/main_view.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class ImageDetailsModal extends StatefulWidget {
  ImageDetailsModal({Key? key, this.selectedImageUrl}) : super(key: key);
  final selectedImageUrl;

  @override
  _ImageDetailsModalState createState() => _ImageDetailsModalState();
}

class _ImageDetailsModalState extends State<ImageDetailsModal> {
  String _avatarImage =
      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg';
  @override
  Widget build(BuildContext context) {
    if (user.user?.photoURL != null) {
      setState(() {
        _avatarImage = user.user!.photoURL!;
      });
    }
    return Scaffold(
      // key: _scaffoldKey,
      backgroundColor: Color.fromARGB(0, 33, 149, 243),
      body: Center(
        child: Container(
          width: Responsive.isDesktop(context)
              ? MediaQuery.of(context).size.width * 0.6
              : MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: BoxDecoration(
              color: kBgDarkColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),

          // color: kBgDarkColor,
          // decoration: BoxDecoration(
          //     color: kBgDarkColor,
          //     borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(20),
          //         topRight: Radius.circular(20),
          //         bottomRight: Radius.circular(20),
          //         bottomLeft: Radius.circular(20))),
          // child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: kDefaultPadding),
              Row(
                children: [
                  // Once user click the menu icon the menu shows like drawer
                  // Also we want to hide this menu icon on desktop
                  if (!Responsive.isDesktop(context))
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: kButtonLightPurple,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  if (!Responsive.isDesktop(context)) SizedBox(width: 5),
                  Container(
                    width: MediaQuery.of(context).size.width - 230,
                    height: 35,
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.all( 15.0),
                    child: Text(
                      "Image Detail",
                      style: TextStyle(
                        fontFamily:
                            'custom font', // remove this if don't have custom font
                        fontSize: 20.0, // text size
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),

                  Positioned(
                    top: MediaQuery.of(context).size.height / 8,
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      width: 45,
                      height: 45,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(_avatarImage),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: kDefaultPadding),
              Container(
                child: Stack(
                  children: [
                    Image.network(
                      widget.selectedImageUrl,
                      // width: 400,
                      // height: 400,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              Container(
                // flex: 1,
                alignment: Alignment.center,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  // Expanded(
                  //Share
                  ElevatedButton(
                    child: Icon(
                      Icons.share,
                      size: 20.0,
                    ),
                    onPressed: () {
                      Share.share(
                          'check out the Image I have generated with Art Gen https://google.com');
                    },
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        primary: Color.fromARGB(255, 181, 9, 130),
                        shape: CircleBorder()),
                    // child: Text('Share'),
                  ),

                  //Image2Image
                  ElevatedButton(
                    child: Icon(
                      Icons.image_rounded,
                      size: 20.0,
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        primary: Color.fromARGB(255, 181, 9, 130),
                        shape: CircleBorder()),
                    // child: Text('Share'),
                  ),
                  ElevatedButton(
                    child: Icon(
                      Icons.refresh,
                      size: 20.0,
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        primary: Color.fromARGB(255, 181, 9, 130),
                        shape: CircleBorder()),
                    // child: Text('Share'),
                  ),
                  // ),
                  // Expanded(
                  //   child: Container(
                  //     // height: 30,
                  //     // width: 80,
                  //     // decoration: BoxDecoration(
                  //     //   borderRadius: BorderRadius.circular(10),
                  //     //   color: kButtonLightPurple,
                  //     // ),
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         primary: Color.fromARGB(255, 181, 9, 130),
                  //         shadowColor: Colors.transparent,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //       ),
                  //       child: Text(
                  //         'Rerun',
                  //         style: TextStyle(
                  //           fontFamily: 'custom font',
                  //           fontSize: 12.0,
                  //         ),
                  //       ),
                  //       onPressed: () {},
                  //     ),
                  //   ),
                  // ),
                  // Expanded(
                  //   child: Container(
                  //     //   height: 30,
                  //     //   width: 80,
                  //     // decoration: BoxDecoration(
                  //     //   color: kButtonLightPurple,
                  //     //   borderRadius: BorderRadius.circular(10),
                  //     // ),
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         primary: Color.fromARGB(255, 181, 9, 130),
                  //         shadowColor: Colors.transparent,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //       ),
                  //       child: Text(
                  //         'Remix',
                  //         style: TextStyle(
                  //           fontFamily: 'custom font',
                  //           fontSize: 12.0,
                  //         ),
                  //       ),
                  //       onPressed: () {},
                  //     ),
                  //   ),
                  // ),
                  // Expanded(
                  // child: Container(
                  //   height: 30,
                  //   width: 80,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(10),
                  //   color: kButtonLightPurple,
                  // ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Color.fromARGB(255, 181, 9, 130),
                  //     shadowColor: Colors.transparent,
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10)),
                  //   ),
                  //   child: Text(
                  //     'Reimage',
                  //     style: TextStyle(
                  //       fontFamily: 'custom font',
                  //       fontSize: 12.0,
                  //     ),
                  //   ),
                  //   onPressed: () {},
                  // ),
                  // ),
                  // ),
                  // Expanded(
                  //   child: Container(
                  //     //   height: 50,
                  //     //   width: 100,
                  //     // decoration: BoxDecoration(
                  //     //   borderRadius: BorderRadius.circular(10),
                  //     //   color: kButtonLightPurple,
                  //     // ),
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         primary: Color.fromARGB(255, 181, 9, 130),
                  //         shadowColor: Colors.transparent,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //       ),
                  //       child: Text(
                  //         'Make Privte',
                  //         style: TextStyle(
                  //           fontFamily: 'custom font',
                  //           fontSize: 12.0,
                  //         ),
                  //       ),
                  //       onPressed: () {},
                  //     ),
                  //   ),
                  // ),
                  // Expanded(
                  //   child: Container(
                  //     //   height: 30,
                  //     //   width: 80,
                  //     // decoration: BoxDecoration(
                  //     //   borderRadius: BorderRadius.circular(10),
                  //     //   color: kButtonLightPurple,
                  //     // ),
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         primary: Color.fromARGB(255, 181, 9, 130),
                  //         shadowColor: Colors.transparent,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //       ),
                  //       child: Text(
                  //         'Delete',
                  //         style: TextStyle(
                  //           fontFamily: 'custom font',
                  //           fontSize: 12.0,
                  //         ),
                  //       ),
                  //       onPressed: () {},
                  //     ),
                  //   ),
                  // ),

                  SizedBox(height: kDefaultPadding),
                  // ],
                  // )
                ]),
              ),
            ],
          ),
          // ),
        ),
      ),
    );
  }
}
