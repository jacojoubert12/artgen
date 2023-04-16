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
      return 'ca-app-pub-9114002398812345/1674218674';
    } else if (UniversalPlatform.isIOS) {
      return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (UniversalPlatform.isAndroid) {
      return 'ca-app-pub-9114002398812345/1437866218';
    } else if (UniversalPlatform.isIOS) {
      return '<YOUR_IOS_REWARDED_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedInterstitialAdUnitId {
    if (UniversalPlatform.isAndroid) {
      return 'ca-app-pub-9114002398812345/9100695828';
    } else if (UniversalPlatform.isIOS) {
      return '<YOUR_IOS_REWARDED_INTERSTITIAL_AD_UNIT_ID>';
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

  static Future<RewardedAd> createRewardedAd() async {
    RewardedAd? rewardedAd;
    final Completer<RewardedAd> completer = Completer<RewardedAd>();

    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          completer.complete(rewardedAd);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Rewarded ad failed to load: $error');
          completer.completeError(error);
        },
      ),
    );

    return completer.future;
  }

  static Future<RewardedInterstitialAd> createRewardedInterstitialAd() async {
    RewardedInterstitialAd? rewardedInterstitialAd;
    final Completer<RewardedInterstitialAd> completer =
        Completer<RewardedInterstitialAd>();

    RewardedInterstitialAd.load(
      adUnitId: AdHelper.rewardedInterstitialAdUnitId,
      request: AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedInterstitialAd = ad;
          completer.complete(rewardedInterstitialAd);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Rewarded interstitial ad failed to load: $error');
          completer.completeError(error);
        },
      ),
    );
    return completer.future;
  }
}
