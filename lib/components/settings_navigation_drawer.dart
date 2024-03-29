import 'package:artgen/constants.dart';
import 'package:artgen/responsive.dart';
import 'package:flutter/material.dart';
import '../views/main/main_view.dart';

class SettingNavigationDrawer extends StatefulWidget {
  SettingNavigationDrawer(
      {Key? key,
      this.setViewMode,
      this.selectedImages,
      this.selectedImageUrls,
      this.updateSelectedImages,
      this.showDetailView})
      : super(key: key);
  final Function? setViewMode;
  final Function? updateSelectedImages;
  final Function? showDetailView;
  final selectedImages;
  final selectedImageUrls;
  List<String> imageUrls = [];
  List<dynamic> images = [];

  @override
  State<SettingNavigationDrawer> createState() =>
      _SettingNavigationDrawerState();
}

class _SettingNavigationDrawerState extends State<SettingNavigationDrawer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(0, 33, 149, 243),
      body: Center(
        child: Container(
          // alignment: Alignment.center,
          width: Responsive.isDesktop(context)
              ? MediaQuery.of(context).size.width * 0.4
              : MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
              color: kBgDarkColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: kDefaultPadding / 6),
              Container(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton(
                    child: Icon(
                      Icons.arrow_back,
                      size: 30.0,
                      color: kButtonLightPurple,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: kTextFieldBoarderColor, shape: CircleBorder()),
                  ),
                ),
              ),

              SizedBox(height: kDefaultPadding),

              Text(
                "Sampling Steps",
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 12.0, // text size
                  color: kTextColorLightGrey,
                ),
              ),
              SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackShape: RoundedRectSliderTrackShape(),
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  ),
                  child: Container(
                    width: Responsive.isDesktop(context)
                        ? MediaQuery.of(context).size.width * 0.35
                        : MediaQuery.of(context).size.width * 0.8,
                    child: Slider(
                      value: user.samplingStepsSliderValue,
                      max: 150,
                      min: 1,
                      divisions: 150,
                      label: user.samplingStepsSliderValue.round().toString(),
                      activeColor:
                          kButtonLightPurple, // Set the active color here
                      inactiveColor:
                          kButtonLightPurpleTransparent, // Set the inactive color here
                      onChanged: (double value) {
                        setState(() {
                          user.samplingStepsSliderValue = value;
                        });
                      },
                    ),
                  )),

              Text(
                "Resolution",
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 12.0, // text size
                  color: kTextColorLightGrey,
                ),
              ),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackShape: RoundedRectSliderTrackShape(),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                ),
                child: Container(
                  width: Responsive.isDesktop(context)
                      ? MediaQuery.of(context).size.width * 0.35
                      : MediaQuery.of(context).size.width * 0.8,
                  child: Slider(
                    value: user.resolutionSliderValue,
                    max: user.resolutionSteps - 1,
                    min: 0,
                    divisions: 9,
                    label:
                        "${user.widths[user.resolutionSliderValue.toInt()]} x ${user.heights[user.resolutionSliderValue.toInt()]}",
                    activeColor:
                        kButtonLightPurple, // Set the active color here
                    inactiveColor:
                        kButtonLightPurpleTransparent, // Set the inactive color here
                    onChanged: (double value) {
                      setState(() {
                        user.resolutionSliderValue = value;
                        user.widthSliderValue =
                            user.widths[user.resolutionSliderValue.toInt()];
                        user.heightSliderValue =
                            user.heights[user.resolutionSliderValue.toInt()];
                      });
                    },
                  ),
                ),
              ),
              Text(
                "Width",
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 12.0, // text size
                  color: kTextColorLightGrey,
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackShape: RoundedRectSliderTrackShape(),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                ),
                child: Container(
                  width: Responsive.isDesktop(context)
                      ? MediaQuery.of(context).size.width * 0.35
                      : MediaQuery.of(context).size.width * 0.8,
                  child: Slider(
                    value: user.widthSliderValue,
                    max: 2048,
                    min: 64,
                    divisions: 1985,
                    label: user.widthSliderValue.round().toString(),
                    activeColor:
                        kButtonLightPurple, // Set the active color here
                    inactiveColor:
                        kButtonLightPurpleTransparent, // Set the inactive color here
                    onChanged: (double value) {
                      setState(() {
                        user.widthSliderValue = value;
                      });
                    },
                  ),
                ),
              ),
              Text(
                "Height",
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 12.0, // text size
                  color: kTextColorLightGrey,
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackShape: RoundedRectSliderTrackShape(),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                ),
                child: Container(
                  width: Responsive.isDesktop(context)
                      ? MediaQuery.of(context).size.width * 0.35
                      : MediaQuery.of(context).size.width * 0.8,
                  child: Slider(
                    value: user.heightSliderValue,
                    max: 2048,
                    min: 64,
                    divisions: 1985,
                    label: user.heightSliderValue.round().toString(),
                    activeColor:
                        kButtonLightPurple, // Set the active color here
                    inactiveColor:
                        kButtonLightPurpleTransparent, // Set the inactive color here
                    onChanged: (double value) {
                      setState(() {
                        user.heightSliderValue = value;
                      });
                    },
                  ),
                ),
              ),
              Text(
                "Guidance Scale",
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 12.0, // text size
                  color: kTextColorLightGrey,
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackShape: RoundedRectSliderTrackShape(),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                ),
                child: Container(
                  width: Responsive.isDesktop(context)
                      ? MediaQuery.of(context).size.width * 0.35
                      : MediaQuery.of(context).size.width * 0.8,
                  child: Slider(
                    value: user.guidanceScaleSliderValue,
                    max: 30,
                    min: 1,
                    divisions: 30,
                    label: user.guidanceScaleSliderValue.round().toString(),
                    activeColor:
                        kButtonLightPurple, // Set the active color here
                    inactiveColor:
                        kButtonLightPurpleTransparent, // Set the inactive color here
                    onChanged: (double value) {
                      setState(() {
                        user.guidanceScaleSliderValue = value;
                      });
                    },
                  ),
                ),
              ),
              Text(
                "Denoising Strength",
                style: TextStyle(
                  fontFamily:
                      'custom font', // remove this if don't have custom font
                  fontSize: 12.0, // text size
                  color: kTextColorLightGrey,
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackShape: RoundedRectSliderTrackShape(),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                ),
                child: Container(
                  width: Responsive.isDesktop(context)
                      ? MediaQuery.of(context).size.width * 0.35
                      : MediaQuery.of(context).size.width * 0.8,
                  child: Slider(
                    value: user.denoisingStrengthSliderValue,
                    max: 1,
                    min: 0,
                    divisions: 101,
                    label: user.denoisingStrengthSliderValue.toString(),
                    activeColor:
                        kButtonLightPurple, // Set the active color here
                    inactiveColor:
                        kButtonLightPurpleTransparent, // Set the inactive color here
                    onChanged: (double value) {
                      setState(() {
                        user.denoisingStrengthSliderValue = value;
                      });
                    },
                  ),
                ),
              ),

              //Dropdown
              SizedBox(height: kDefaultPadding),
              Container(
                width: 180,
                height: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: kTextFieldBackgroundColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(kDefaultBorderRadius)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: kDropDownGrey,
                      isExpanded: true,
                      value: user.selectedModel,
                      borderRadius: BorderRadius.circular(20),
                      itemHeight: 50,
                      items: user.modelList
                          .map<DropdownMenuItem<String>>((String dropDownText) {
                        return DropdownMenuItem<String>(
                            value: dropDownText,
                            child: Row(
                              children: [
                                SizedBox(width: kDefaultWidth),
                                Expanded(
                                  child: Text(
                                    dropDownText,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(
                                      fontSize: kTextFontSize,
                                      color: kTextColorLightGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          user.selectedModel = newValue!;
                          user.pubTopic = user.selectedModel;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: kDefaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
