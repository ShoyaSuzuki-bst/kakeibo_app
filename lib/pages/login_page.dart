import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:kakeibo_app/modules/kakeibo_server_client.dart';
import 'package:kakeibo_app/parts/loading.dart';
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

  void _signIn() async {
    _loadingHandler(true);
    GoogleSignInAccount? signinAccount = await googleLogin.signIn();
    if (signinAccount == null) return;
    GoogleSignInAuthentication auth = await signinAccount.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );
    User? user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    if (user != null) {
      String token = await user.getIdToken();
      final res = await KakeiboServerClient.getUser(token);
      _loadingHandler(false);
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
                FlatButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _signUp() async {
    _loadingHandler(true);
    GoogleSignInAccount? signinAccount = await googleLogin.signIn();
    if (signinAccount == null) return;
    GoogleSignInAuthentication auth =
        await signinAccount.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );
    User? user =
        (await FirebaseAuth.instance.signInWithCredential(credential))
            .user;
    if (user != null) {
      String token = await user.getIdToken();
      final res = await KakeiboServerClient.signUp(
        token,
        user.displayName,
        user.email
      );
      _loadingHandler(false);
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
                FlatButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          overflow: Overflow.clip,
          children: <Widget>[
            OverlayLoadingMolecules(isVisible: _isLoading),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    child: const Text(
                      'ようこそ',
                      style: TextStyle(
                        fontSize: 50,
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
                          onPressed: _signIn,
                        ),
                        SignInButton(
                          Buttons.Google,
                          text: 'Googleでアカウント作成',
                          onPressed: _signUp,
                        ),
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
