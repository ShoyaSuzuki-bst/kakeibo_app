import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakeibo_app/modules/admob_module.dart';


class BottomBannerAd extends StatefulWidget {
  @override
  _BottomBannerAd createState() => _BottomBannerAd();

}

class _BottomBannerAd extends State<BottomBannerAd> {
  final BannerAd bottomBannerAd = BannerAd(
    adUnitId: AdmobModule.getTestAdBannerUnitId(),
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
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