import 'package:artgen/views/main_detail_views/createimg_detail_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class AdMob extends StatelessWidget {
  const AdMob({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdMobView();
    // TODO: implement build
    // throw UnimplementedError();
  }
}

class AdMobView extends StatefulWidget {
  const AdMobView({Key? key}) : super(key: key);
  @override
  State<AdMobView> createState() => _AdMobViewState();
}

// class AdHelper {
//   static String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return '<YOUR_ANDROID_BANNER_AD_UNIT_ID>';
//     } else if (Platform.isIOS) {
//       return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
//     } else {
//       throw UnsupportedError('Unsupported platform');
//     }
//   }

//   static String get interstitialAdUnitId {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-3940256099942544/1033173712';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/1033173712';
//     } else {
//       throw UnsupportedError('Unsupported platform');
//     }
//   }

//   static String get rewardedAdUnitId {
//     if (Platform.isAndroid) {
//       return '<YOUR_ANDROID_REWARDED_AD_UNIT_ID>';
//     } else if (Platform.isIOS) {
//       return '<YOUR_IOS_REWARDED_AD_UNIT_ID>';
//     } else {
//       throw UnsupportedError('Unsupported platform');
//     }
//   }
// }

class _AdMobViewState extends State<AdMobView> {
  //Members
  //ad
  late final InterstitialAd interstitialAd;
  final String interstitialAdUnitId = 'ca-app-pub-9114002398812345/6628994086';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //load adds
    _loadInterstitialAd();
  }

  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              CreateImgDetailView();
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void _setFullScreenCcontentCallBack(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print("$ad onAsShowedFullScreenContent"),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print("$ad onAsShowedFullScreenContent");
        //dispose the dismissed ad
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print("$ad onAdFailedToShowFullScreenContent: $error");
      },
      onAdImpression: (InterstitialAd ad) => print("$ad Impression occured"),
    );
  }

  void _showInterstitialAd() {
    interstitialAd.show();
  }

  //load ads
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: InkWell(
        onTap: _showInterstitialAd,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            height: 100,
            color: Colors.deepPurple,
            child: const Text(
              "Show Interstital Ad",
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            )),
      )),
    );
  }
}
