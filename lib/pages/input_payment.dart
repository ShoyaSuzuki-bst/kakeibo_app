import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputPayment extends StatefulWidget {
  @override
  _InputPaymentState createState() => _InputPaymentState();
}

class _InputPaymentState extends State<InputPayment> {
  bool _isIncome = false;
  String _price = '';
  String _income = '支出';

  void _handleRadio(bool? v) => setState(() {
    v != null ? _isIncome = v : _isIncome = false;
    if(_isIncome) {
      _income = '収入';
    }else{
      _income = '支出';
    }
  });

  void _changePrice(price) {
    setState(() {
      _price = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支出登録'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _income,
              style: const TextStyle(
                fontSize: 100,
              )
            ),
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
                  width: 300,
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
              onPressed: () {},
              color: Colors.blue,
              child: const Text(
                '更新',
                style: TextStyle(
                    color:Colors.white,
                    fontSize: 20.0
                ),),
            )
          ]
        ),
      ),
    );
  }
}