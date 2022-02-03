import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:kakeibo_app/modules/kakeibo_server_client.dart';
import 'package:kakeibo_app/parts/loading.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'base_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  bool _isLoading = false;

  void _loadingHandler(bool v) {
    setState(() {
      _isLoading = v;
    });
  }

  void _showLoadingDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 250), // ダイアログフェードインmsec
      barrierColor: Colors.black.withOpacity(0.5), // 画面マスクの透明度
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  void _checkSignInResult(User? user) async {
    if (user != null) {
      String token = await user.getIdToken();
      final res = await KakeiboServerClient.getUser(token);
      Navigator.pop(context);
      if (res['status'] == 200) {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return BasePage();
          }),
        );
      }else{
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text("エラー"),
                ]
              ),
              content: Text(res['message']),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _signInWithGoogle() async {
    _showLoadingDialog();
    try{
      GoogleSignInAccount? signinAccount = await googleLogin.signIn();
      if (signinAccount == null) {
        Navigator.pop(context);
        return;
      }
      GoogleSignInAuthentication auth = await signinAccount.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
        accessToken: auth.accessToken,
      );
      User? user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      _checkSignInResult(user);
    } on Exception catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text("エラー"),
              ]
            ),
            content: Text("$e"),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _signInWithApple() async {
    try{
      _showLoadingDialog();
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      User? user = (await FirebaseAuth.instance.signInWithCredential(oauthCredential)).user;
      _checkSignInResult(user);
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text("エラー"),
              ]
            ),
            content: Text("$e"),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: const Text(
                  'ようこそ',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SignInButton(
                      Buttons.Google,
                      text: 'Googleでログイン',
                      onPressed: _signInWithGoogle,
                    ),
                    if (Platform.isIOS) SignInButton(
                      Buttons.AppleDark,
                      text: 'Appleでログイン',
                      onPressed: _signInWithApple,
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
