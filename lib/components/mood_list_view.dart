import 'package:flutter/material.dart';
import 'package:artgen/models/mood.dart';
import 'package:artgen/responsive.dart';
import 'package:artgen/views/main_center_views/mood_card.dart';
import 'package:artgen/views/main_detail_views/mood_detail_view.dart';

class MoodListViewWidget extends StatelessWidget {
  const MoodListViewWidget({
    Key key,
    this.setSelectedMood,
  }) : super(key: key);
  final Function setSelectedMood;

  ListView getListView() {
    int selectedIndex = 0;
    return ListView.builder(
      itemCount: moods.length,
      // On mobile this active dosen't mean anything
      itemBuilder: (context, index) => MoodCard(
        isActive: Responsive.isMobile(context) ? false : selectedIndex == index,
        mood: moods[index],
        press: () {
          selectedIndex = index;
          setSelectedMood(moods[index]);
          Responsive.isMobile(context)
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoodDetailView(mood: moods[index]),
                  ))
              : true;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getListView();
  }
}
