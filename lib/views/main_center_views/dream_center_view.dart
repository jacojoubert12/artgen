import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:artgen/components/my_input_theme.dart';
import 'package:artgen/components/rounded_button.dart';
import 'package:artgen/components/tag_field.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class DreamCenterView extends StatefulWidget {
  const DreamCenterView({
    Key key,
    this.setViewMode,
  }) : super(key: key);
  final Function setViewMode;

  @override
  _DreamCenterViewState createState() => _DreamCenterViewState();
}

class _DreamCenterViewState extends State<DreamCenterView> {
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: kDefaultPadding,
                  ),
                  Expanded(flex: 2, child: dateField()),
                  SizedBox(
                    width: kDefaultPadding,
                    height: 5.0,
                  ),
                  Expanded(flex: 1, child: timeField()),
                  SizedBox(
                    width: kDefaultPadding,
                    height: 5.0,
                  ),
                ],
              ),
              SizedBox(height: kDefaultMargin),
              titleField(),
              SizedBox(height: kDefaultMargin),
              dreamField(),
              SizedBox(height: kDefaultMargin),
              tagField(),
              RoundedButton(
                text: "Voice",
                press: () {},
              ),
              RoundedButton(
                text: "Save",
                press: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dateField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Date",
        hintText: "11/11/2022",
      ),
    );
  }

  Widget timeField() {
    return TextField(
      decoration: InputDecoration(
        labelText: "Time",
        hintText: "14:00",
      ),
    );
  }

  Widget titleField() {
    return TextField(
      decoration: InputDecoration(
        labelText: "Title",
        hintText: "",
      ),
    );
  }

  Widget dreamField() {
    return TextField(
      decoration: InputDecoration(
        labelText: "Dream",
        hintText: "",
      ),

      autofocus: false,
      // focusNode: _focusnode,
      maxLines: null,
      minLines: 5,
      // controller: _newreplycontroller,
      keyboardType: TextInputType.text,
    );
  }

  Widget tagField() {
    return TagField();
  }
}
