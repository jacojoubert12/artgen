import 'dart:convert';

import 'package:artgen/views/main_center_views/createimg_center_view.dart';
import 'package:artgen/views/main_detail_views/createimg_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';

import 'package:artgen/views/main_center_views/mygallary_center_view.dart';
import 'package:artgen/views/main_center_views/likes_center_view.dart';
import 'package:artgen/views/main_center_views/explore_center_view.dart';
import 'package:artgen/views/main_center_views/profile_center_view.dart';
import 'package:artgen/views/main_center_views/about_center_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:artgen/auth_gate.dart';

enum ViewMode { create, mygallary, explore, likes, profile, about, share }

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("artgen")),
      body: MainScreen(user: user),
      // body: MainScreen(),
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
  var viewMode = ViewMode.create;
  // FireStoreManager fireStoreManager = FireStoreManager();
  // StreamBuilder<List<Mood>> moodsStreamBuilder;
  ImgGridView createImgCenterView;
  CreateImgDetailView createImgDetailView;
  Set<dynamic> selectedImages = new Set<dynamic>();
  Set<String> selectedImageUrls = new Set<String>();

  bool shouldShowDetailView = true;

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
      viewMode == ViewMode.create
          ? shouldShowDetailView = true
          : shouldShowDetailView = false;
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
      case ViewMode.create:
        centerView = createImgCenterView;
        break;
      case ViewMode.mygallary:
        centerView = MyGallaryCenterView(setViewMode: setViewMode);
        break;
      case ViewMode.explore:
        centerView = ExploreCenterView(setViewMode: setViewMode);
        break;
      case ViewMode.likes:
        centerView = LikesCenterView(setViewMode: setViewMode);
        break;
      case ViewMode.profile:
        centerView = ProfileCenterView(setViewMode: setViewMode);
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
      case ViewMode.create:
        return this.createImgDetailView;
        break;
      // case ViewMode.mygallary:
      //   return mygallaryDetailView;
      //   break;
      default:
        return this.createImgDetailView;
    }
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
            shouldShowDetailView
                ? Expanded(
                    flex: 9,
                    child: getViewModeDetailView(),
                  )
                : Expanded(
                    flex: 0,
                    child: Text(""),
                  ),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(
              flex: _size.width > 1340 ? 3 : 5,
              child: SideMenu(
                setViewMode: setViewMode,
              ),
            ),
            Expanded(
                flex: _size.width > 1340 ? 8 : 12,
                child: getViewModeCenterView()),
            shouldShowDetailView
                ? Expanded(
                    flex: _size.width > 1340 ? 12 : 15,
                    child: getViewModeDetailView(),
                  )
                : Expanded(
                    flex: 0,
                    child: Text(""),
                  ),
          ],
        ),
      ),
    );
  }
}
