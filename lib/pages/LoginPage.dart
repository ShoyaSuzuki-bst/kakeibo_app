import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:kakeibo_app/modules/kakeibo_server_client.dart';
import 'InputPayment.dart';

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
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
                  String? email = user.email;
                  final res = await KakeiboServerClient.signIn(email, token);
                  if (res['status'] == 200) {
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return InputPayment();
                      }),
                    );
                  }
                }
              },
            ),
          ]
        ),
      ),
    );
  }
}
