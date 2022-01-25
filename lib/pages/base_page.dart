import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakeibo_app/modules/kakeibo_server_client.dart';
import 'package:kakeibo_app/parts/bottom_banner_ad.dart';
import 'input_payment.dart';
import 'index_payments.dart';
import 'current_user.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _index = 0;
  List _payments = [];
  PageController _pageController = PageController();

  void _getPayments() async {
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final res = await KakeiboServerClient.getPayments(token);
    setState(() {
      _payments = res['data'];
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _getPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Flutter App'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            this._index = index;
          });
        },
        children: [
          InputPayment(),
          IndexPayments(payments: _payments, getPayments: _getPayments),
          CurrentUser(),
        ]
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BottomBannerAd(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) { // define animation
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 10), curve: Curves.ease);
        },
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem( // call each bottom item
            icon: Icon(Icons.create),
            title: Text('入力'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('履歴'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('マイページ'))
        ],
      ),
    );
  }
}