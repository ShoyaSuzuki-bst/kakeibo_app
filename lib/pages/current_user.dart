import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakeibo_app/modules/kakeibo_server_client.dart';
import 'login_page.dart';

class CurrentUser extends StatefulWidget {
  @override
  _CurrentUser createState() => _CurrentUser();
}

class _CurrentUser extends State<CurrentUser> {
  final String _userName = 'hoge';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.person, size: 100),
              Text("${FirebaseAuth.instance.currentUser!.displayName}", style: TextStyle(fontSize: 50)),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  await Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));
                },
                child: const Text('ログアウト', style: TextStyle(fontSize: 30)),
              )
            ],
          ),
        ),
      ),
    );
  }
}