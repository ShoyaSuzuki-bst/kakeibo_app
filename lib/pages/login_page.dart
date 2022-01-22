import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:kakeibo_app/modules/kakeibo_server_client.dart';
import 'logout_page.dart';
import 'input_payment.dart';

class LoginPage extends StatelessWidget {
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: Center(
        child: 
        Card(
          elevation: 10,
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('---ログイン---', style: TextStyle(fontSize: 30)),
                SignInButton(
                  Buttons.Google,
                  text: 'ログイン with Google',
                  onPressed: () async {
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
                      if (res['status'] == 200) {
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return InputPayment();
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
                  },
                ),
                const Text('---新規登録---', style: TextStyle(fontSize: 30)),
                SignInButton(
                  Buttons.Google,
                  text: '新規登録 with Google',
                  onPressed: () async {
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
                      if (res['status'] == 200) {
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return InputPayment();
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
                  },
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
