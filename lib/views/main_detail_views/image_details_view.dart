import 'package:artgen/components/rounded_button.dart';
import 'package:artgen/constants.dart';
import 'package:artgen/responsive.dart';
import 'package:flutter/material.dart';

class ImageDetailsModal extends StatefulWidget {
  @override
  _ImageDetailsModalState createState() => _ImageDetailsModalState();
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
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: kDefaultPadding),
            // Large Image
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Image.network(
                    "http://localhost:5000/output/" + "output.png",
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

            // 2 Buttons next to each other
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: kDefaultPadding),
                  SizedBox(width: kDefaultPadding),
                  Expanded(
                    child: RoundedButton(
                      press: () {},
                      text: 'Button 1',
                    ),
                  ),
                  SizedBox(width: kDefaultPadding),
                  Expanded(
                    child: RoundedButton(
                      press: () {},
                      text: 'Button 2',
                    ),
                  ),
                  SizedBox(width: kDefaultPadding),
                  SizedBox(width: kDefaultPadding),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: kDefaultPadding),
                  SizedBox(width: kDefaultPadding),
                  Expanded(
                    child: RoundedButton(
                      press: () {},
                      text: 'Button 3',
                    ),
                  ),
                  SizedBox(width: kDefaultPadding),
                  Expanded(
                    child: RoundedButton(
                      press: () {},
                      text: 'Button 4',
                    ),
                  ),
                  SizedBox(width: kDefaultPadding),
                  Expanded(
                    child: RoundedButton(
                      press: () {},
                      text: 'Button 5',
                    ),
                  ),
                  SizedBox(width: kDefaultPadding),
                  SizedBox(width: kDefaultPadding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
