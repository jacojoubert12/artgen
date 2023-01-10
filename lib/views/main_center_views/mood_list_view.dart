import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:artgen/models/mood.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class MoodListView extends StatefulWidget {
  const MoodListView({Key key, this.setViewMode, this.moodsStream})
      : super(key: key);
  final Function setViewMode;
  final StreamBuilder moodsStream;

  @override
  _MoodListViewState createState() => _MoodListViewState();
}

class _MoodListViewState extends State<MoodListView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _MoodListViewState() {}

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
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              Expanded(
                child: moods.length == 0
                    ? CircularProgressIndicator()
                    : widget.moodsStream,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
