import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:artgen/models/influx_manager.dart';
import 'package:artgen/models/mood.dart';
import 'package:artgen/components/my_input_theme.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../extensions.dart';

class MoodCard extends StatefulWidget {
  MoodCard({
    Key key,
    this.isActive = true,
    this.mood,
    this.press,
  }) : super(key: key);

  final bool isActive;
  final Mood mood;
  final VoidCallback press;

  @override
  State<MoodCard> createState() => _MoodCardState();
}

class _MoodCardState extends State<MoodCard> {
  double _currentSliderValue = 0;
  DateTime backDate = DateTime.now();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  Timer _timer;
  String autoSaveText = "Save";
  String cancelText = "";
  bool startAutoSaveTime = false;
  int autoSaveTimeLeft = 3;

  _MoodCardState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer _timer) async {
      String saveBtnText;
      if (autoSaveTimeLeft > 0 && startAutoSaveTime) {
        --autoSaveTimeLeft;
        saveBtnText =
            "Auto Save in: " + (autoSaveTimeLeft + 1).toString() + 's';
        cancelText = "Cancel";
      } else {
        saveBtnText = "Save";
        if (startAutoSaveTime) {
          startAutoSaveTime = false;
          saveMoodValue();
        }
      }
      // print(autoSaveTimeLeft);
      setState(() {
        autoSaveText = saveBtnText;
      });
    });
  }

  saveMoodValue() {
    cancelText = "";
    print("Saving Mood");
    print(_currentSliderValue);
    widget.mood.moodValue = _currentSliderValue as int;
    InfluxManager influxManager = InfluxManager();
    influxManager.updateMoodValue(widget.mood, backDate: backDate.toUtc());
  }

  @override
  initState() {
    super.initState();
    _currentSliderValue = widget.mood.moodValue as double;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  Here the shadow is not showing properly
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      child: InkWell(
        onTap: widget.press,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                color: widget.isActive ? kPrimaryColor : kBgDarkColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          // backgroundImage: AssetImage(email.image),
                        ),
                      ),
                      SizedBox(width: kDefaultPadding / 2),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "${widget.mood.moodName} \n",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color:
                                  widget.isActive ? Colors.white : kTextColor,
                            ),
                            children: [
                              TextSpan(
                                text: widget.mood.moodName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: widget.isActive
                                          ? Colors.white
                                          : kTextColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            dateFormat.format(backDate).toString(),
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color:
                                      widget.isActive ? Colors.white70 : null,
                                ),
                          ),
                          TextButton(
                            onPressed: () {
                              DatePicker.showDateTimePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day - 2),
                                  maxTime: DateTime.now(),
                                  onChanged: (date) {}, onConfirm: (date) {
                                setState(() {
                                  backDate = date;
                                });
                              }, currentTime: DateTime.now());
                            },
                            child: Text(
                              'Back Date',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                    height: 1.5,
                                    color:
                                        widget.isActive ? Colors.white70 : null,
                                  ),
                            ),
                          ),
                          // SizedBox(height: 5),
                          // if (email.isAttachmentAvailable)
                          //   SvgPicture.asset(
                          //     "assets/Icons/Paperclip.svg",
                          //     color: isActive ? Colors.white70 : kGrayColor,
                          //   )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: kDefaultPadding / 2),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.mood.moodWorst,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption.copyWith(
                                height: 1.5,
                                color: widget.isActive ? Colors.white70 : null,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.mood.moodMid,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption.copyWith(
                                height: 1.5,
                                color: widget.isActive ? Colors.white70 : null,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.mood.moodBest,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption.copyWith(
                                height: 1.5,
                                color: widget.isActive ? Colors.white70 : null,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _currentSliderValue,
                    min: -100,
                    max: 100,
                    divisions: 200,
                    // label: _currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                        autoSaveTimeLeft = 3; //TODO: Change to settings value
                        startAutoSaveTime = true;
                      });
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(""),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            startAutoSaveTime = false;
                            saveMoodValue();
                          },
                          child: Text(
                            autoSaveText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  height: 1.5,
                                  color:
                                      widget.isActive ? Colors.white70 : null,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      startAutoSaveTime
                          ? Expanded(
                              child: TextButton(
                                onPressed: () {
                                  startAutoSaveTime = false;
                                },
                                child: Text(
                                  cancelText,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                        height: 1.5,
                                        color: widget.isActive
                                            ? Colors.white70
                                            : null,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Expanded(
                              child: Text(""),
                            ),
                    ],
                  ),
                ],
              ),
            ).addNeumorphism(
              blurRadius: 15,
              borderRadius: 15,
              offset: Offset(5, 5),
              topShadowColor: Colors.white60,
              bottomShadowColor: Color(0xFF234395).withOpacity(0.15),
            ),
          ],
        ),
      ),
    );
  }
}
