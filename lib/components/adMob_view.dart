import 'dart:async';
import 'package:universal_platform/universal_platform.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  static String get bannerAdUnitId {
    if (UniversalPlatform.isAndroid) {
      return 'ca-app-pub-9114002398812345/6058765368';
    } else if (UniversalPlatform.isIOS) {
      return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (UniversalPlatform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (UniversalPlatform.isIOS) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}

class AdManager {
  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    );
  }

  static Future<InterstitialAd> createInterstitialAd() async {
    InterstitialAd? interstitialAd;
    final Completer<InterstitialAd> completer = Completer<InterstitialAd>();

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          completer.complete(interstitialAd);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
          completer.completeError(error);
        },
      ),
    );

    return completer.future;
  }
}
