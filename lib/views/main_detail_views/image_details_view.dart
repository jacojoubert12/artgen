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
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: BoxDecoration(
              color: kBgDarkColor,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
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
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Image.network(
                    widget.selectedImageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
