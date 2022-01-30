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
  final List _pageTitles = [
    '収支入力',
    '履歴',
    'マイページ'
  ];
  int _index = 0;
  List _payments = [];
  bool _isLoading = false;
  bool _isEnableBottomSheet = false;
  String _title = '収支入力';
  PageController _pageController = PageController();

  void _getPayments() async {
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final res = await KakeiboServerClient.getPayments(token);
    setState(() {
      _payments = res['data'];
    });
  }

  void _toggleBottomSheet(bool v) {
    setState(() {
      _isEnableBottomSheet = v;
    });
  }

  void _updatePayment(int id, payment) {
    final index = _payments.indexWhere((p) => p['id'] == id);
    setState(() {
      _payments.removeAt(index);
      _payments.insert(index, payment);
    });
  }

  void _insertPayments(payment) {
    setState(() {
      _payments.insert(0, payment);
    });
  }

  void _deletePayment(int id) async {
    final index = _payments.indexWhere((p) => p['id'] == id);
    setState(() {
      _payments.removeAt(index);
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
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
                    _title = _pageTitles[index];
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
                    updatePayment: _updatePayment,
                    deletePayment: _deletePayment,
                    toggleBottomSheet: _toggleBottomSheet,
                  ),
                  CurrentUser(),
                ]
              ),
            ],
          ),
        ),
        bottomNavigationBar: _isEnableBottomSheet ? null : Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            BottomBannerAd(),
            BottomNavigationBar(
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
                  label: 'マイページ'
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}