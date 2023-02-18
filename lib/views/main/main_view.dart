import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:artgen/main.dart';
import 'package:artgen/models/my_user.dart';
import 'package:artgen/views/main_center_views/createimg_center_view.dart';
import 'package:artgen/views/main_detail_views/createimg_detail_view.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:device_uuid/device_uuid.dart';
import 'package:flutter/foundation.dart';
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
import 'package:platform_device_id/platform_device_id.dart';

enum ViewMode { create, mygallary, explore, likes, profile, about, share }

MyUser user = MyUser();

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("artgen")),
      // body: MainScreen(user: user),
      body: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
    // this.user,
  }) : super(key: key);
  // final MyUser? user;

  @override
  State<MainScreen> createState() => _Mainviewstate();
}

class _Mainviewstate extends State<MainScreen> {
  // View Mode: Menue select om die center view te kies
  var viewMode = ViewMode.create;
  ImgGridView? createImgCenterView;
  CreateImgDetailView? createImgDetailView;
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
        updateSelectedImages: this.updateSelectedImages,
        setViewMode: this.setViewMode);

    getDeviceInfo();
    user.initMyUser();
    // user = MyUser();
  }

  getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo1 = DeviceInfoPlugin();

    // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"

    // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    // print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"

    WebBrowserInfo webBrowserInfo = await deviceInfo1.webBrowserInfo;
    print('Running on ${webBrowserInfo.userAgent}');

    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    final result = await PlatformDeviceId.getDeviceId;

    // String uid = await DeviceId.getID!;
    print(allInfo);
    print(result);

    // print(user?.isAnonymous);
  }

  setViewMode(viewMode) {
    if (Responsive.isMobile(context)) Navigator.pop(context);
    if (Responsive.isMobile(context)) Navigator.pop(context);
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
            updateSelectedImages: this.updateSelectedImages,
            setViewMode: this.setViewMode);
      }
    });
  }

  showDetailView() {
    if (Responsive.isMobile(context))
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => createImgDetailView!,
          ));
  }

  StatefulWidget? getViewModeCenterView() {
    StatefulWidget? centerView;
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

  StatefulWidget? getViewModeDetailView() {
    switch (viewMode) {
      case ViewMode.create:
        return this.createImgDetailView;
      // case ViewMode.mygallary:
      //   return mygallaryDetailView;
      //   break;
      default:
        return this.createImgDetailView;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        // Let's work on our mobile part
        mobile: getViewModeCenterView(),
        tablet: Row(
          children: [
            Expanded(
              flex: 9,
              child: getViewModeDetailView()!,
            ),
            shouldShowDetailView
                ? Expanded(
                    flex: 6,
                    child: getViewModeCenterView()!,
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
                flex: _size.width > 1340 ? 12 : 15,
                child: getViewModeDetailView()!),
            shouldShowDetailView
                ? Expanded(
                    flex: _size.width > 1340 ? 8 : 12,
                    child: getViewModeCenterView()!,
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
