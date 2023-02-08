import 'package:artgen/components/rounded_button.dart';
import 'package:artgen/constants.dart';
import 'package:artgen/responsive.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class ImageDetailsModal extends StatefulWidget {
  ImageDetailsModal({Key? key, this.selectedImageUrl}) : super(key: key);
  final selectedImageUrl;

  @override
  _ImageDetailsModalState createState() => _ImageDetailsModalState();
  // final Icon icon;
}

class _ImageDetailsModalState extends State<ImageDetailsModal> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: kDefaultPadding),
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Image.network(
                    widget.selectedImageUrl,
                    // width: 400,
                    // height: 400,
                    fit: BoxFit.cover,
                  ),
                  // Positioned(
                  //   top: 10,
                  //   right: 10,
                  //   child: IconButton(
                  //     icon: Icon(Icons.favorite),
                  //     onPressed: () {},
                  //     color: Colors.red,
                  //   ),
                  // ),
                ],
              ),
            ),

            // 2 Buttons next to each other
            Expanded(
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 61, 2, 50),
                          Color.fromARGB(255, 10, 6, 20)
                        ])),
                    child: ElevatedButton(
                      onPressed: () {
                        Share.share(
                            'check out the Image I have generated with Art Gen https://google.com');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Share'),
                    ),
                  ),
                  SizedBox(
                    child: Text('Safe Search'),
                  ),
                  LiteRollingSwitch(
                    //initial value
                    value: false,
                    textOn: 'Yes',
                    textOff: 'No',
                    colorOn: Colors.greenAccent[700]!,
                    colorOff: Colors.redAccent[700]!,
                    iconOn: Icons.done,
                    iconOff: Icons.remove_circle_outline,
                    textSize: 10.0,

                    onSwipe: (bool state) {}, onChanged: (bool) {},
                    onTap: () {}, onDoubleTap: () {},
                    // onChanged: (bool state) {
                    //   //Use it to manage the different states
                    //   print('Current State of SWITCH IS: $state');
                    // },
                  ),
                  // Expanded(
                  //   child: RoundedButton(
                  //     press: () {},
                  //     text: 'Button 2',
                  //   ),
                  // ),
                  // SizedBox(width: kDefaultPadding),
                  // SizedBox(width: kDefaultPadding),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 35.0,
                    width: 350,
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
                      child: Text('Enhance'),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 35.0,
                    width: 155,
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
                  Container(
                    height: 35.0,
                    width: 155,
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
                  Container(
                    height: 35.0,
                    width: 155,
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
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  SizedBox(height: kDefaultPadding),
                  Text('Text View 1'),
                  SizedBox(height: kDefaultPadding),
                  // Text('Text View 2'),
                  // SizedBox(height: kDefaultPadding),
                  // Text('Text View 3'),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 35.0,
                    width: 200,
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
                  Container(
                    height: 35.0,
                    width: 200,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
