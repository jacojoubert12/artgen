import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';

class AboutCenterView extends StatefulWidget {
  const AboutCenterView({Key? key, this.setViewMode}) : super(key: key);
  final Function? setViewMode;

  @override
  _AboutCenterViewState createState() => _AboutCenterViewState();
}

class _AboutCenterViewState extends State<AboutCenterView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _backgroundImage = 'https://ws.artgen.fun/images/icon.png';

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
                        "About ArtGen",
                        style: TextStyle(
                          fontFamily:
                              'custom font', // remove this if don't have custom font
                          fontSize: 20.0, // text size
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: double.infinity,
                    color: kBgDarkColor,
                    child: SafeArea(
                      right: false,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 200 + kDefaultPadding,
                            left: kDefaultPadding * 4,
                            right: kDefaultPadding * 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: kDefaultPadding),
                            Text(
                              "About ArtGen",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 20.0, // text size
                                color: kTextColorLightGrey, // text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding),
                            Text(
                              "Welcome to ArtGen, the brainchild of a passionate indie developer striving to bring the power of artificial intelligence to the creative world. Our art generation app harnesses the potential of AI to revolutionize the way artists, designers, and hobbyists alike create and explore visual art.",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 15.0, // text size
                                color: kTextColorLightGrey, // text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding * 2),
                            Text(
                              "Our Vision",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 20.0, // text size
                                color: kTextColorLightGrey, // text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding),
                            Text(
                              "ArtGen was born out of a love for the creative process and a belief that technology can be a force for enhancing human creativity. We envision a world where artificial intelligence and human imagination blend seamlessly to create stunning, unique, and thought-provoking art.",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 15.0, // text size
                                color: kTextColorLightGrey, // text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding * 2),
                            Text(
                              "Our Technology",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 20.0, // text size
                                color: kTextColorLightGrey, // text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding),
                            Text(
                              "Powered by the latest advancements in AI, ArtGen's app uses deep learning algorithms to generate images based on users' input and preferences. Our intuitive interface allows you to easily customize the style, color palette, and level of abstraction in your artwork. With ArtGen, the creative possibilities are virtually endless.",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 15.0, // text size
                                color: kTextColorLightGrey, // text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding * 2),
                            Text(
                              "Our Commitment",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 20.0, // text size
                                color: kTextColorLightGrey, // text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding),
                            Text(
                              "As an indie developer, we are committed to providing a user-friendly, innovative, and powerful tool that empowers individuals to express themselves artistically. We are dedicated to maintaining a platform that fosters creativity, growth, and exploration while respecting the privacy and intellectual property rights of our users.",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 15.0, // text size
                                color: kTextColorLightGrey, // text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding * 2),
                            Text(
                              "Join the ArtGen Community",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 20.0, // text size
                                color: kTextColorLightGrey, // text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding),
                            Text(
                              "ArtGen is more than just an app; it's a community of artists, designers, and enthusiasts who are passionate about the intersection of art and technology. By joining our community, you'll gain access to exclusive content, tutorials, and events, as well as the opportunity to connect with like-minded individuals who share your passion for AI-driven creativity. Participate in collaborative projects, showcase your creations, and engage in meaningful discussions on the ever-evolving world of AI art.",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 15.0, // text size
                                color: kTextColorLightGrey, // text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding * 2),
                            Text(
                              "Stay Inspired",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 20.0, // text size
                                color: kTextColorLightGrey, // text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding),
                            Text(
                              "We invite you to explore ArtGen and unleash your inner artist. With our groundbreaking app, you'll be part of a new wave of creators pushing the boundaries of what's possible in the realm of visual art. Embrace the future, and let ArtGen inspire you to create the extraordinary.",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 15.0, // text size
                                color: kTextColorLightGrey, // text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding * 2),
                            Text(
                              "Thank you for visiting ArtGen. We look forward to sharing this creative journey with you.",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 15.0, // text size
                                color: kTextColorLightGrey, // text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding),
                            Text(
                              "GenNet",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 20.0, // text size
                                color: kTextColorLightGrey, // text color
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding / 2),
                            Text(
                              "GenNet is dedicated to delivering a scalable framework that enables applications to harness the power of a distributed worker network for AI inference, while also rewarding participants for contributing their processing capabilities. Initially focusing on AI-driven image generation, our long-term vision encompasses the provision of diverse AI services, such as text, video, voice, and sound generation and classification, among others. By leveraging the untapped potential of idle time on home and office systems, we aim to offer these services at more competitive prices than traditional cloud providers.\n\n While we are still getting things ready before releasing GenNet, please feel free to contact us if you are interested in joining the network.",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 15.0, // text size
                                color: kTextColorLightGrey,
                              ),
                              textAlign: TextAlign.center,
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
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: kDefaultPadding / 2),
                            Text(
                              "support@enginosoft.com\n",
                              style: TextStyle(
                                fontFamily:
                                    'custom font', // remove this if don't have custom font
                                fontSize: 15.0, // text size
                                color: kTextColorLightGrey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: () {
                                // Replace the URL with your privacy policy link
                                launchUrl(
                                    'https://docs.google.com/document/d/17KdTKpDdhprAPpvhMeRsL6rp7OQuXBtUfsC0vWkdGVU/edit?usp=share_link'
                                        as Uri);
                              },
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: kDefaultPadding * 2,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 200 + kDefaultPadding,
            width: double.maxFinite,
            color: kBgDarkColor,
            child: Image(
              image: AssetImage('assets/images/flower.png'),
              fit: BoxFit.cover,
            ),
            padding: EdgeInsets.only(bottom: kDefaultPadding),
          )
        ],
      ),
    );
  }
}
