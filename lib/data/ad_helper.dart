import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2024059982025359/1190163326";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2024059982025359/1190163326";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2024059982025359/6381962983";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2024059982025359/6381962983";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
