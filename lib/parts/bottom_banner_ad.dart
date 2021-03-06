import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakeibo_app/modules/admob_module.dart';


class BottomBannerAd extends StatefulWidget {
  @override
  _BottomBannerAd createState() => _BottomBannerAd();

}

class _BottomBannerAd extends State<BottomBannerAd> {
  final BannerAd bottomBannerAd = BannerAd(
    adUnitId: AdmobModule.getAdBannerUnitId(),
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  @override
  void initState() {
    super.initState();
    bottomBannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: bottomBannerAd.size.width.toDouble(),
      height: bottomBannerAd.size.height.toDouble(),
      child: AdWidget(ad: bottomBannerAd),
    );
  }
}