import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakeibo_app/modules/kakeibo_server_client.dart';

class InputPayment extends StatefulWidget {
  @override
  _InputPaymentState createState() => _InputPaymentState();
}

class _InputPaymentState extends State<InputPayment> {
  bool _isIncome = false;
  String _price = '';

  void _handleRadio(bool? v) => setState(() {
    v != null ? _isIncome = v : _isIncome = false;
  });

  void _changePrice(price) {
    setState(() {
      _price = price;
    });
  }

  void _submitValue() async {
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final res = await KakeiboServerClient.createPayment(token, int.parse(_price), _isIncome);
    if (res['status'] == 200) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text("完了"),
              ]
            ),
            content: const Text('保存しました。'),
            actions: <Widget>[
              FlatButton(
                child: const Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                activeColor: Colors.blue,
                value: false,
                groupValue: _isIncome,
                onChanged: _handleRadio,
              ),
              const Text('支出'),
              Radio(
                activeColor: Colors.blue,
                value: true,
                groupValue: _isIncome,
                onChanged: _handleRadio,
              ),
              const Text('収入'),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('¥', style: TextStyle(fontSize: 50)),
              SizedBox(
                width: 250,
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  autofocus: true,
                  onChanged: (text) {
                    _changePrice(text);
                  },
                  style: const TextStyle(
                    fontSize: 40
                  )
                ),
              ),
            ]
          ),
          RaisedButton(
            onPressed: _price == '' ? null :  () {
              _submitValue();
            },
            color: Colors.blue,
            child: const Text(
              '保存',
              style: TextStyle(
                  color:Colors.white,
                  fontSize: 20.0
              ),
            ),
          )
        ]
      ),
    );
  }
}