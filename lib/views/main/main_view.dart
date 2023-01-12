import 'dart:convert';

import 'package:artgen/views/main_center_views/createimg_center_view.dart';
import 'package:artgen/views/main_detail_views/createimg_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:artgen/components/mood_list_view.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/models/firestore_manager.dart';
import 'package:artgen/models/influx_manager.dart';
import 'package:artgen/responsive.dart';

import 'package:artgen/models/mood.dart';
import 'package:artgen/models/dream.dart';
import 'package:artgen/models/journal.dart';
import 'package:artgen/views/main_detail_views/mood_detail_view.dart';
import 'package:artgen/views/main_detail_views/dream_detail_view.dart';
import 'package:artgen/views/main_detail_views/journal_detail_view.dart';
import 'package:artgen/views/main_center_views/activness_center_view.dart';
import 'package:artgen/views/main_center_views/badges_center_view.dart';
import 'package:artgen/views/main_center_views/calander_center_view.dart';
import 'package:artgen/views/main_center_views/diet_center_view.dart';
import 'package:artgen/views/main_center_views/community_center_view.dart';
import 'package:artgen/views/main_center_views/dream_center_view.dart';
import 'package:artgen/views/main_center_views/mood_list_view.dart';
import 'package:artgen/views/main_center_views/journal_center_view.dart';
import 'package:artgen/views/main_center_views/physical_center_view.dart';
import 'package:artgen/views/main_center_views/profile_center_view.dart';
import 'package:artgen/views/main_center_views/settings_center_view.dart';
import 'package:artgen/views/main_center_views/supplements_center_view.dart';
import 'package:artgen/views/main_center_views/about_center_view.dart';
import 'dart:developer' as developer;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:artgen/auth_gate.dart';

enum ViewMode { search, browse, profile, settings, share, about }

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("artgen")),
      body: MainScreen(user: user),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key key,
    this.user,
  }) : super(key: key);
  final User user;

  @override
  State<MainScreen> createState() => _Mainviewstate();
}

class _Mainviewstate extends State<MainScreen> {
  // View Mode: Menue select om die center view te kies
  var viewMode = ViewMode.search;
  // FireStoreManager fireStoreManager = FireStoreManager();
  // StreamBuilder<List<Mood>> moodsStreamBuilder;
  ImgGridView createImgCenterView;
  CreateImgDetailView createImgDetailView;
  Set<String> selectedImages = new Set<String>();
  Set<String> selectedImageUrls = new Set<String>();

  _Mainviewstate() {
    createImgCenterView = ImgGridView(
      selectedImages: selectedImages,
      selectedImageUrls: selectedImageUrls,
      updateSelectedImages: this.updateSelectedImages,
      showDetailView: this.showDetailView,
      setViewMode: this.setViewMode,
    );

    createImgDetailView = CreateImgDetailView(
        selectedImages: selectedImages,
        selectedImageUrls: selectedImageUrls,
        updateSelectedImages: this.updateSelectedImages);
  }

  setViewMode(viewMode) {
    setState(() {
      this.viewMode = viewMode;
    });
  }

  updateSelectedImages(selectedImageSet, selectedImageUrls) {
    setState(() {
      this.selectedImages = selectedImages;
      this.selectedImageUrls = selectedImageUrls;
      if (!Responsive.isMobile(context)) {
        createImgDetailView = CreateImgDetailView(
            selectedImages: selectedImages,
            selectedImageUrls: selectedImageUrls,
            updateSelectedImages: this.updateSelectedImages);
      }
    });

    getViewModeDetailView();
  }

  showDetailView() {
    if (Responsive.isMobile(context))
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => createImgDetailView,
          ));
  }

  StatefulWidget getViewModeCenterView() {
    StatefulWidget centerView;
    switch (viewMode) {
      case ViewMode.search:
        centerView = createImgCenterView;
        break;
      case ViewMode.profile:
        centerView = ProfileCenterView(setViewMode: setViewMode);
        break;
      case ViewMode.settings:
        centerView = SettingsCenterView(setViewMode: setViewMode);
        break;
      case ViewMode.about:
        centerView = AboutCenterView(setViewMode: setViewMode);
        break;
      default:
        centerView = createImgCenterView;
    }
    return centerView;
  }

  StatefulWidget getViewModeDetailView() {
    switch (viewMode) {
      case ViewMode.search:
        return this.createImgDetailView;
        break;
      // case ViewMode.dreams:
      //   return dreamDetailView;
      //   break;
      // case ViewMode.supplements:
      //   return supplementDetailView;
      //   break;
      // case ViewMode.diet:
      // return dietDetailView;
      // break;
      // case ViewMode.physical:
      // return physicalDetailView;
      // break;
      // case ViewMode.activness:
      // return activnessDetailView;
      // break;
      // case ViewMode.journal:
      //   return journalDetailView;
      //   break;
      // case ViewMode.community:
      // return communityDetailView;
      // break;
      // case ViewMode.share:
      // return shareDetailView;
      // break;
      // case ViewMode.profile:
      // return profileDetailView;
      // break;
      // case ViewMode.settings:
      // return settingsDetailView;
      // break;
      // case ViewMode.calander:
      // return calanderDetailView;
      // break;
      //  case ViewMode.badges:
      // return badgeDetailView;
      // break;
      // case ViewMode.about:
      // return aboutDetailView;
      // break;
      default:
        return this.createImgDetailView;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        // Let's work on our mobile part
        mobile: getViewModeCenterView(),
        tablet: Row(
          children: [
            Expanded(
              flex: 6,
              child: getViewModeCenterView(),
            ),
            Expanded(
              flex: 9,
              child: getViewModeDetailView(),
            ),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(
              flex: _size.width > 1340 ? 2 : 4,
              child: SideMenu(
                setViewMode: setViewMode,
              ),
            ),
            Expanded(
                flex: _size.width > 1340 ? 3 : 5,
                child: getViewModeCenterView()),
            Expanded(
              flex: _size.width > 1340 ? 8 : 10,
              child: getViewModeDetailView(),
            ),
          ],
        ),
      ),
    );
  }
}
