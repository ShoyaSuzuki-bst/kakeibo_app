import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'LoginPage.dart';

class LogoutPage extends StatelessWidget {
  User user;
  LogoutPage(this.user);
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Hello ${user.displayName}", style: TextStyle(fontSize: 50)),
            SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                await googleLogin.signIn();
                await Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              },
              child: Text('Logout', style: TextStyle(fontSize: 50)),
            )
          ],
        ),
      ),
    );
  }
}
