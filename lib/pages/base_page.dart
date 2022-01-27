import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakeibo_app/modules/kakeibo_server_client.dart';
import 'package:kakeibo_app/parts/bottom_banner_ad.dart';
import 'package:kakeibo_app/parts/loading.dart';
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
  bool _isLoading = false;
  String _title = '家計簿アプリ';
  PageController _pageController = PageController();

  void _getPayments() async {
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final res = await KakeiboServerClient.getPayments(token);
    setState(() {
      _payments = res['data'];
    });
  }

  void _changeTitle(String title) {
    setState(() {
      _title = title;
    });
  }

  void _insertPayments(payment) async {
    setState(() {
      _payments.insert(0, payment);
    });
  }

  void _loadingHandler(bool v) {
    setState(() {
      _isLoading = v;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getPayments();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Flutter App'),
      ),
      body: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          overflow: Overflow.clip,
          children: <Widget>[
            OverlayLoadingMolecules(isVisible: _isLoading),
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  _index = index;
                });
              },
              children: [
                InputPayment(
                  loadingHandler: _loadingHandler,
                  insertPayment: _insertPayments,
                ),
                IndexPayments(
                  payments: _payments,
                  getPayments: _getPayments,
                  loadingHandler: _loadingHandler,
                ),
                CurrentUser(),
              ]
            ),
          ],
        ),
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
            label: '入力',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '履歴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'マイページ')
        ],
      ),
    );
  }
}