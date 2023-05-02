import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/models/offerings_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class SubscriptionView extends StatefulWidget {
  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  @override
  void initState() {
    getOfferings();
    super.initState();
  }

  void getOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      print(offerings);
      if (offerings.current != null) {
        // Display current offering with offerings.current
      }
    } on PlatformException catch (e) {
      print("Error getting Offerings: ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          // decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(20),
          //         topRight: Radius.circular(20),
          //         bottomRight: Radius.circular(20),
          //         bottomLeft: Radius.circular(20))),
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                decoration: BoxDecoration(
                    color: Color.fromARGB(112, 181, 5, 134),
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://ws.artgen.fun/images/icon.png'),
                        fit: BoxFit.cover)),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration:
                    BoxDecoration(color: Color.fromARGB(112, 181, 5, 134)),
                child: Responsive.isMobile(context)
                    ? Column(children: getSubscriptions())
                    : Row(children: getSubscriptions()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getSubscriptions() {
    return [
      SizedBox(
        //Use of SizedBox
        height: 30,
      ),
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(35)),
            color: Color.fromARGB(255, 31, 30, 30)),
        child: Column(
          children: <Widget>[
            Text(
              'Starter',
              style: TextStyle(
                fontFamily:
                    'custom font', // remove this if don't have custom font
                fontSize: 20.0, // text size
                color: Color.fromARGB(255, 255, 251, 251), // text color
              ),
            ),
            Text(
              'Monthly Plan',
              style: TextStyle(
                fontFamily:
                    'custom font', // remove this if don't have custom font
                fontSize: 15.0, // text size
                color: Color.fromARGB(255, 255, 255, 255), // text color
              ),
            ),
            SizedBox(height: 10),
            Text(
              '''
                -No Adds
                -1000 Images Per month
                -Share Image on Social Media
                -Public Image
                -Moderate Speed and Quality
                -Prompt Length 50 Words
               -Not safe for work images can not be viewed
                -Batch Generation - Batches of 10 images
                -Model Style Selection
                Watermark on image
              ''',
              style: TextStyle(
                fontFamily:
                    'custom font', // remove this if don't have custom font
                fontSize: 15.0, // text size
                color: Color.fromARGB(255, 255, 255, 255), // text color
              ),
            ),
            Text(
              '\$8',
              style: TextStyle(
                fontFamily:
                    'custom font', // remove this if don't have custom font
                fontSize: 30.0, // text size
                color: Color.fromARGB(255, 255, 255, 255), // text color
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('Subscribe'),
            ),
          ],
        ),
      ),
      SizedBox(
        //Use of SizedBox
        height: 20,
      ),
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(35)),
            color: Color.fromARGB(255, 31, 30, 30)),
        child: Column(
          children: <Widget>[
            Text(
              'Pro',
              style: TextStyle(
                fontFamily:
                    'custom font', // remove this if don't have custom font
                fontSize: 20.0, // text size
                color: Color.fromARGB(255, 255, 255, 255), // text color
              ),
            ),
            Text(
              'Monthly Plan',
              style: TextStyle(
                fontFamily:
                    'custom font', // remove this if don't have custom font
                fontSize: 15.0, // text size
                color: Color.fromARGB(255, 255, 255, 255), // text color
              ),
            ),
            SizedBox(height: 10),
            Text(
              '''
                -No Adds
                -4000 Images Per month
                -Share Image on Social Media
                -Public Image
                -Fast Speed and Good Quality
                -Extra Prompt words,  Length of 100 Words
                -See Prompt of chosen images
                -Not safe for work images can not be viewed
                -All Settings Available
                -Batch Generation - Batches of 100 images
                -Model Style Selection
                -No Watermark on image
              ''',
              style: TextStyle(
                fontFamily:
                    'custom font', // remove this if don't have custom font
                fontSize: 15.0, // text size
                color: Color.fromARGB(255, 255, 255, 255), // text color
              ),
            ),
            Text(
              '\$25',
              style: TextStyle(
                fontFamily:
                    'custom font', // remove this if don't have custom font
                fontSize: 30.0, // text size
                color: Color.fromARGB(255, 255, 255, 255), // text color
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Subscribe'),
            ),
          ],
        ),
      ),
      SizedBox(
        //Use of SizedBox
        height: 20,
      ),
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(35)),
            color: Color.fromARGB(255, 31, 30, 30)),
        child: Column(
          children: <Widget>[
            Text(
              'Max',
              style: TextStyle(
                fontFamily:
                    'custom font', // remove this if don't have custom font
                fontSize: 20.0, // text size
                color: Color.fromARGB(255, 255, 255, 255), // text color
              ),
            ),
            Text(
              'Monthly Plan',
              style: TextStyle(
                fontFamily:
                    'custom font', // remove this if don't have custom font
                fontSize: 15.0, // text size
                color: Color.fromARGB(255, 255, 255, 255), // text color
              ),
            ),
            SizedBox(height: 10),
            Text(
              '''
                -No Adds
                -4000 Images Per month
                -Share Image on Social Media
                -Public Image
                -Fast Speed and Good Quality
                -Extra Prompt words,  Length of 100 Words
                -See Prompt of chosen images
                -Not safe for work images can not be viewed
                -All Settings Available
                -Batch Generation - Batches of 100 images
                -Model Style Selection
                -No Watermark on image
              ''',
              style: TextStyle(
                fontFamily:
                    'custom font', // remove this if don't have custom font
                fontSize: 15.0, // text size
                color: Color.fromARGB(255, 255, 255, 255), // text color
              ),
            ),
            Text(
              '\$25',
              style: TextStyle(
                fontFamily:
                    'custom font', // remove this if don't have custom font
                fontSize: 30.0, // text size
                color: Color.fromARGB(255, 255, 255, 255), // text color
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('Subscribe'),
            ),
          ],
        ),
      ),
      SizedBox(
        //Use of SizedBox
        height: 30,
      ),
    ];
  }
}
