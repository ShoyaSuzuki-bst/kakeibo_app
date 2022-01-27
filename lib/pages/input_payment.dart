import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:kakeibo_app/modules/kakeibo_server_client.dart';

class InputPayment extends StatefulWidget {
  InputPayment({
    Key? key,
    required this.loadingHandler,
    required this.insertPayment,
  }) : super(key: key);

  final loadingHandler;
  final insertPayment;
  @override
  _InputPaymentState createState() => _InputPaymentState();
}

class _InputPaymentState extends State<InputPayment> {
  bool _isIncome = false;
  String _price = '';

  void _handleRadio(bool? v) => setState(() {
    v != null ? _isIncome = v : _isIncome = false;
  });

  void _incomeHandler(bool v) {
    setState(() {
      _isIncome = v;
    });
  }

  Widget _toggleButton(bool v, String text) {
    if(v == _isIncome) {
      return ElevatedButton(
        onPressed: () {},
        child: Text(text),
      );
    }else{
      return OutlinedButton(
        onPressed:() {
          _incomeHandler(v);
        },
        child: Text(text),
      );
    }
  }

  void _changePrice(price) {
    setState(() {
      _price = price;
    });
  }

  void _submitValue() async {
    widget.loadingHandler(true);
    widget.insertPayment({
      'is_income': _isIncome,
      'price': int.parse(_price),
      'created_at': DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
    });
    print(DateFormat('yyyy/M/d').format(DateTime.now()));
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final res = await KakeiboServerClient.createPayment(token, int.parse(_price), _isIncome);
    widget.loadingHandler(false);
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
              _toggleButton(false, '支出'),
              _toggleButton(true, '収入'),
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
          ElevatedButton(
            onPressed: _price == '' ? null :  () {
              _submitValue();
            },
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