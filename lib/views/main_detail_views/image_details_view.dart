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
      body: Container(
        // color: kBgDarkColor,
        decoration: BoxDecoration(
            color: kBgDarkColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: SafeArea(
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
                        color: Color.fromARGB(255, 144, 142, 142),
                      ),
                    ),
                  ),

                  Positioned(
                    top: MediaQuery.of(context).size.height / 8,
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: Container(
                      margin: EdgeInsets.only(left: 40),
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(_avatarImage),
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
              Expanded(
                // flex: 1,
                child: Column(children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Icon(
                                Icons.share,
                                size: 20.0,
                              ),
                              onPressed: () {
                                Share.share(
                                    'check out the Image I have generated with Art Gen https://google.com');
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(212, 162, 4, 141),
                                  shadowColor: Colors.transparent,
                                  shape: CircleBorder()),
                              // child: Text('Share'),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Color.fromARGB(255, 61, 2, 50),
                                    Color.fromARGB(255, 10, 6, 20)
                                  ])),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text('Rerun'),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Color.fromARGB(255, 61, 2, 50),
                                    Color.fromARGB(255, 10, 6, 20)
                                  ])),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text('Remix'),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Color.fromARGB(255, 61, 2, 50),
                                    Color.fromARGB(255, 10, 6, 20)
                                  ])),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text('Reimage'),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Color.fromARGB(255, 61, 2, 50),
                                    Color.fromARGB(255, 10, 6, 20)
                                  ])),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text('Make Privte'),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Color.fromARGB(255, 61, 2, 50),
                                    Color.fromARGB(255, 10, 6, 20)
                                  ])),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text('Delete'),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      )),
                  // Row(
                  //   children: [
                  //     Container(
                  //       height: 50,
                  //       width: 100,
                  //       child: ElevatedButton(
                  //         child: Icon(
                  //           Icons.share,
                  //           size: 20.0,
                  //         ),
                  //         onPressed: () {},
                  //         style: ElevatedButton.styleFrom(
                  //             backgroundColor: Color.fromARGB(212, 162, 4, 141),
                  //             shadowColor: Colors.transparent,
                  //             shape: CircleBorder()),
                  //         // child: Text('Share'),
                  //       ),
                  //     ),

                  // SizedBox(
                  //   child: Text('Safe Search'),
                  // ),
                  // LiteRollingSwitch(
                  //   //initial value
                  //   value: false,
                  //   textOn: 'Search Safe',
                  //   textOff: 'Unsafe',
                  //   colorOn: Colors.greenAccent[700]!,
                  //   colorOff: Colors.redAccent[700]!,
                  //   iconOn: Icons.done,
                  //   iconOff: Icons.remove_circle_outline,
                  //   textSize: 10.0,

                  //   onSwipe: (bool state) {}, onChanged: (bool) {},
                  //   onTap: () {}, onDoubleTap: () {},
                  // ),
                  // Container(
                  //   height: 35,
                  //   width: 100,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       gradient: LinearGradient(colors: [
                  //         Color.fromARGB(255, 61, 2, 50),
                  //         Color.fromARGB(255, 10, 6, 20)
                  //       ])),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.transparent,
                  //       shadowColor: Colors.transparent,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10)),
                  //     ),
                  //     child: Text('Enhance'),
                  //     onPressed: () {},
                  //   ),
                  // ),
                  // Container(
                  //   height: 50,
                  //   width: 100,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       gradient: LinearGradient(colors: [
                  //         Color.fromARGB(255, 61, 2, 50),
                  //         Color.fromARGB(255, 10, 6, 20)
                  //       ])),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.transparent,
                  //       shadowColor: Colors.transparent,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10)),
                  //     ),
                  //     child: Text('Rerun'),
                  //     onPressed: () {},
                  //   ),
                  // ),
                  // Container(
                  //   height: 50,
                  //   width: 100,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       gradient: LinearGradient(colors: [
                  //         Color.fromARGB(255, 61, 2, 50),
                  //         Color.fromARGB(255, 10, 6, 20)
                  //       ])),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.transparent,
                  //       shadowColor: Colors.transparent,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10)),
                  //     ),
                  //     child: Text('Remix'),
                  //     onPressed: () {},
                  //   ),
                  // ),
                  // Container(
                  //   height: 50,
                  //   width: 100,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       gradient: LinearGradient(colors: [
                  //         Color.fromARGB(255, 61, 2, 50),
                  //         Color.fromARGB(255, 10, 6, 20)
                  //       ])),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.transparent,
                  //       shadowColor: Colors.transparent,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10)),
                  //     ),
                  //     child: Text('Reimage'),
                  //     onPressed: () {},
                  //   ),
                  // ),
                  // Container(
                  //   height: 50,
                  //   width: 100,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       gradient: LinearGradient(colors: [
                  //         Color.fromARGB(255, 61, 2, 50),
                  //         Color.fromARGB(255, 10, 6, 20)
                  //       ])),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.transparent,
                  //       shadowColor: Colors.transparent,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10)),
                  //     ),
                  //     child: Text('Make Privte'),
                  //     onPressed: () {},
                  //   ),
                  // ),
                  // Container(
                  //   height: 50,
                  //   width: 100,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       gradient: LinearGradient(colors: [
                  //         Color.fromARGB(255, 61, 2, 50),
                  //         Color.fromARGB(255, 10, 6, 20)
                  //       ])),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.transparent,
                  //       shadowColor: Colors.transparent,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10)),
                  //     ),
                  //     child: Text('Delete'),
                  //     onPressed: () {},
                  //   ),
                  // ),
                  SizedBox(height: kDefaultPadding),
                  // ],
                  // )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // return Center(
  //   child: Container(
  //     // width: Responsive.isDesktop(context)
  //     //     ? MediaQuery.of(context).size.width * 0.8
  //     //     : MediaQuery.of(context).size.width * 0.95,
  //     // height: MediaQuery.of(context).size.height * 0.95,
  //     decoration: BoxDecoration(
  //         color: kBgDarkColor,
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(20),
  //             topRight: Radius.circular(20),
  //             bottomRight: Radius.circular(20),
  //             bottomLeft: Radius.circular(20))),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         SizedBox(height: kDefaultPadding),
  //         Container(
  //           // height: 35.0,
  //           // width: 50,
  //           child: Align(
  //             alignment: Alignment.topLeft,
  //             child: ElevatedButton(
  //               child: Icon(
  //                 Icons.arrow_back,
  //                 size: 30.0,
  //                 color: kButtonLightPurple,
  //               ),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               style: ElevatedButton.styleFrom(
  //                   primary: Color.fromARGB(0, 181, 9, 129),
  //                   onPrimary: Colors.black,
  //                   shape: CircleBorder()),
  //             ),
  //           ),
  //         ),
  //         Container(
  //           // width: MediaQuery.of(context).size.width - 230,
  //           height: 35,
  //           alignment: Alignment.center,
  //           // padding: const EdgeInsets.all( 15.0),
  //           child: Text(
  //             "Image Detail",
  //             style: TextStyle(
  //               fontFamily:
  //                   'custom font', // remove this if don't have custom font
  //               fontSize: 20.0, // text size
  //               color: Color.fromARGB(255, 144, 142, 142),
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           top: MediaQuery.of(context).size.height / 8,
  //           left: MediaQuery.of(context).size.width / 2 - 50,
  //           child: Container(
  //             margin: EdgeInsets.only(left: 40),
  //             width: 40,
  //             height: 40,
  //             child: CircleAvatar(
  //               backgroundImage: NetworkImage(_avatarImage),
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           top: MediaQuery.of(context).size.height / 8,
  //           left: MediaQuery.of(context).size.width / 2 - 50,
  //           child: Container(
  //             margin: EdgeInsets.only(left: 20),
  //             width: 45,
  //             height: 45,
  //             child: CircleAvatar(
  //               backgroundImage: NetworkImage(_avatarImage),
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: kDefaultPadding),
  //         Expanded(
  //           child: Stack(
  //             children: [
  //               Image.network(
  //                 widget.selectedImageUrl,
  //                 // width: 400,
  //                 // height: 400,
  //                 fit: BoxFit.contain,
  //               ),
  //             ],
  //           ),
  //         ),
  //         Row(
  //           children: [
  //             Container(
  //               height: 50,
  //               width: 100,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   gradient: LinearGradient(colors: [
  //                     Color.fromARGB(255, 61, 2, 50),
  //                     Color.fromARGB(255, 10, 6, 20)
  //                   ])),
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   Share.share(
  //                       'check out the Image I have generated with Art Gen https://google.com');
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.transparent,
  //                   shadowColor: Colors.transparent,
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10)),
  //                 ),
  //                 child: Text('Share'),
  //               ),
  //             ),
  //             // SizedBox(
  //             //   child: Text('Safe Search'),
  //             // ),
  //             // LiteRollingSwitch(
  //             //   //initial value
  //             //   value: false,
  //             //   textOn: 'Search Safe',
  //             //   textOff: 'Unsafe',
  //             //   colorOn: Colors.greenAccent[700]!,
  //             //   colorOff: Colors.redAccent[700]!,
  //             //   iconOn: Icons.done,
  //             //   iconOff: Icons.remove_circle_outline,
  //             //   textSize: 10.0,

  //             //   onSwipe: (bool state) {}, onChanged: (bool) {},
  //             //   onTap: () {}, onDoubleTap: () {},
  //             // ),
  //             // Container(
  //             //   height: 35,
  //             //   width: 100,
  //             //   decoration: BoxDecoration(
  //             //       borderRadius: BorderRadius.circular(10),
  //             //       gradient: LinearGradient(colors: [
  //             //         Color.fromARGB(255, 61, 2, 50),
  //             //         Color.fromARGB(255, 10, 6, 20)
  //             //       ])),
  //             //   child: ElevatedButton(
  //             //     style: ElevatedButton.styleFrom(
  //             //       backgroundColor: Colors.transparent,
  //             //       shadowColor: Colors.transparent,
  //             //       shape: RoundedRectangleBorder(
  //             //           borderRadius: BorderRadius.circular(10)),
  //             //     ),
  //             //     child: Text('Enhance'),
  //             //     onPressed: () {},
  //             //   ),
  //             // ),
  //             Container(
  //               height: 50,
  //               width: 100,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   gradient: LinearGradient(colors: [
  //                     Color.fromARGB(255, 61, 2, 50),
  //                     Color.fromARGB(255, 10, 6, 20)
  //                   ])),
  //               child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.transparent,
  //                   shadowColor: Colors.transparent,
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10)),
  //                 ),
  //                 child: Text('Rerun'),
  //                 onPressed: () {},
  //               ),
  //             ),
  //             Container(
  //               height: 50,
  //               width: 100,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   gradient: LinearGradient(colors: [
  //                     Color.fromARGB(255, 61, 2, 50),
  //                     Color.fromARGB(255, 10, 6, 20)
  //                   ])),
  //               child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.transparent,
  //                   shadowColor: Colors.transparent,
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10)),
  //                 ),
  //                 child: Text('Remix'),
  //                 onPressed: () {},
  //               ),
  //             ),
  //             Container(
  //               height: 50,
  //               width: 100,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   gradient: LinearGradient(colors: [
  //                     Color.fromARGB(255, 61, 2, 50),
  //                     Color.fromARGB(255, 10, 6, 20)
  //                   ])),
  //               child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.transparent,
  //                   shadowColor: Colors.transparent,
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10)),
  //                 ),
  //                 child: Text('Reimage'),
  //                 onPressed: () {},
  //               ),
  //             ),
  //             Container(
  //               height: 50,
  //               width: 100,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   gradient: LinearGradient(colors: [
  //                     Color.fromARGB(255, 61, 2, 50),
  //                     Color.fromARGB(255, 10, 6, 20)
  //                   ])),
  //               child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.transparent,
  //                   shadowColor: Colors.transparent,
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10)),
  //                 ),
  //                 child: Text('Make Privte'),
  //                 onPressed: () {},
  //               ),
  //             ),
  //             Container(
  //               height: 50,
  //               width: 100,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   gradient: LinearGradient(colors: [
  //                     Color.fromARGB(255, 61, 2, 50),
  //                     Color.fromARGB(255, 10, 6, 20)
  //                   ])),
  //               child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.transparent,
  //                   shadowColor: Colors.transparent,
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10)),
  //                 ),
  //                 child: Text('Delete'),
  //                 onPressed: () {},
  //               ),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   ),
  // );
}
