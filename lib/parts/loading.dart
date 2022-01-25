import 'package:flutter/material.dart';

class OverlayLoadingMolecules extends StatelessWidget {
  OverlayLoadingMolecules({
    required this.isVisible
    });

  //表示状態
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                 CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
              ],
            ),
          )
        : Container();
  }
}