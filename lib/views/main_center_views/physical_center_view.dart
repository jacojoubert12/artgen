import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class PhysicalCenterView extends StatefulWidget {
  const PhysicalCenterView({Key key, this.setViewMode,}) : super(key: key);
  final Function setViewMode;
// class PhysicalCenterView extends StatefulWidget {
//   // Press "Command + ."
//   const PhysicalCenterView({
//     Key key,
//   }) : super(key: key);

  @override
  _PhysicalCenterViewState createState() => _PhysicalCenterViewState();
}

class _PhysicalCenterViewState extends State<PhysicalCenterView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    // Once user click the menu icon the menu shows like drawer
                    // Also we want to hide this menu icon on desktop
                    if (!Responsive.isDesktop(context))
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                      ),
                    if (!Responsive.isDesktop(context)) SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: "Search",
                          fillColor: kBgLightColor,
                          filled: true,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(
                                kDefaultPadding * 0.75), //15
                            child: WebsafeSvg.asset(
                              "assets/Icons/Search.svg",
                              width: 24,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: kDefaultPadding),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              //   child: Row(
              //     children: [
              //       WebsafeSvg.asset(
              //         "assets/Icons/Angle down.svg",
              //         width: 16,
              //         color: Colors.black,
              //       ),
              //       SizedBox(width: 5),
              //       Text(
              //         "Sort by date",
              //         style: TextStyle(fontWeight: FontWeight.w500),
              //       ),
              //       Spacer(),
              //       MaterialButton(
              //         minWidth: 20,
              //         onPressed: () {},
              //         child: WebsafeSvg.asset(
              //           "assets/Icons/Sort.svg",
              //           width: 16,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: kDefaultPadding),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: alerts.length,
              //     // On mobile this active dosen't mean anything
              //     itemBuilder: (context, index) => AlertCard(
              //       isActive: Responsive.isMobile(context) ? false : index == 0,
              //       alert: alerts[index],
              //       press: () {
              //         widget.setSelectedAlert(alerts[index]);
              //         Responsive.isMobile(context)
              //             ? Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) =>
              //                       AlertDetailView(alert: alerts[index]),
              //                   // Iframe(alerts[index]),
              //                 ))
              //             : true;
              //         // Navigator.push(
              //         //   context,
              //         //   MaterialPageRoute(
              //         //     builder: (context) =>
              //         //         AlertDetailView(alert: alerts[index]),
              //         //   ),
              //         // );
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
