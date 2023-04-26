import 'package:artgen/models/my_user.dart';
import 'package:artgen/views/main_center_views/createimg_center_view.dart';
import 'package:artgen/views/main_detail_views/createimg_detail_view.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:artgen/components/side_menu.dart';
import 'package:artgen/responsive.dart';

import 'package:artgen/views/main_center_views/mygallery_center_view.dart';
import 'package:artgen/views/main_center_views/likes_center_view.dart';
import 'package:artgen/views/main_center_views/explore_center_view.dart';
import 'package:artgen/views/main_center_views/profile_center_view.dart';
import 'package:artgen/views/main_center_views/about_center_view.dart';
import 'package:platform_device_id/platform_device_id.dart';

enum ViewMode { create, mygallery, explore, likes, profile, about, share }

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
  }

  void setDfaultResolution() {
    if (Responsive.isDesktop(context)) {
      user.resolutionSliderValue = 0;
    } else {
      user.resolutionSliderValue = 9;
    }
    user.widthSliderValue = user.widths[user.resolutionSliderValue.toInt()];
    user.heightSliderValue = user.heights[user.resolutionSliderValue.toInt()];
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
    // if (Responsive.isMobile(context)) Navigator.pop(context);
    // if (Responsive.isMobile(context)) Navigator.pop(context);
    setState(() {
      viewMode == ViewMode.create
          ? shouldShowDetailView = true
          : shouldShowDetailView = false;
      this.viewMode = viewMode;
    });
    setDfaultResolution();
  }

  void setSettingsFromSelected(var _selectedImages) {
    List<String> models = [];
    List<double> guidanceScales = [];
    List<double> samplingSteps = [];

    for (var selectedImg in _selectedImages) {
      if (selectedImg.toString().contains('img2img')) continue;
      // int samplingSteps =
      // selectedImg["_source"]["details"]["parameters"]["steps"];
      // int width = selectedImg["_source"]["details"]["parameters"]["width"];
      // int height = selectedImg["_source"]["details"]["parameters"]["height"];
      String model = selectedImg["_source"]["model"];
      double guidanceScale =
          selectedImg['_source']['details']['parameters']['cfg_scale'];
      models.add(model);
      guidanceScales.add(guidanceScale);
    }
    String? mostCommonModel = models.isEmpty
        ? null
        : models.reduce((a, b) => models.where((model) => model == a).length >
                models.where((model) => model == b).length
            ? a
            : b);
    double? averageGuidanceScale = guidanceScales.isEmpty
        ? null
        : guidanceScales.reduce((a, b) => a + b) / guidanceScales.length;
    double? averageSamplingSteps = samplingSteps.isEmpty
        ? null
        : samplingSteps.reduce((a, b) => a + b) / samplingSteps.length;

    if (mostCommonModel != null) user.selectedModel = mostCommonModel;
    if (averageGuidanceScale != null)
      user.guidanceScaleSliderValue = averageGuidanceScale;
    if (averageSamplingSteps != null)
      user.samplingStepsSliderValue = averageSamplingSteps;
    print("Most common model: $mostCommonModel");
    print("Average guidance scale: $averageGuidanceScale");
  }

  updateSelectedImages(selectedImageSet, selectedImageUrls) {
    setSettingsFromSelected(selectedImageSet);
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
      case ViewMode.mygallery:
        centerView = MyGalleryCenterView(setViewMode: setViewMode);
        break;
      case ViewMode.explore:
        centerView = ExploreCenterView(setViewMode: setViewMode);
        break;
      // case ViewMode.likes:
      // centerView = LikesCenterView(setViewMode: setViewMode);
      // break;
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
      // case ViewMode.mygallery:
      //   return mygalleryDetailView;
      //   break;
      default:
        return this.createImgDetailView;
    }
  }

  @override
  void initState() {
    super.initState();
    user.initMyUser();
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
            Expanded(flex: 1, child: getViewModeCenterView()!),
            shouldShowDetailView
                ? Expanded(
                    flex: 1,
                    child: getViewModeDetailView()!,
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
              flex: _size.width > 1340
                  ? viewMode == ViewMode.create
                      ? 6
                      : 3
                  : viewMode == ViewMode.create
                      ? 6
                      : 3,
              child: SideMenu(
                setViewMode: setViewMode,
              ),
            ),
            Expanded(
                flex: _size.width > 1340 ? 15 : 15,
                child: viewMode == ViewMode.create
                    ? getViewModeDetailView()!
                    : getViewModeCenterView()!),
            shouldShowDetailView
                ? Expanded(
                    flex: _size.width > 1340 ? 15 : 15,
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
