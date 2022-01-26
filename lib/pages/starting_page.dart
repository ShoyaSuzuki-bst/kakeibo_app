import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakeibo_app/pages/base_page.dart';
import 'package:kakeibo_app/pages/login_page.dart';

class StartingPage extends StatefulWidget {
  @override
  _StartingPage createState() => _StartingPage();
}

class _StartingPage extends State<StartingPage> {
  void _initWithCheckUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return LoginPage();
          }),
        );
      }else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return BasePage();
          }),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initWithCheckUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal,
              Colors.green,
            ],
          ),
        ),
        child: const Center(
          child: Text(
            'K',
            style: TextStyle(
              fontSize: 80,
              color: Colors.white,
            ),
          ),
        )
      )
    );
  }
}