import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:kakeibo_app/modules/kakeibo_server_client.dart';

class InputPayment extends StatefulWidget {
  InputPayment({
    Key? key,
    required this.loadingHandler,
    this.insertPayment,
    this.updatePayment,
    this.paymentData,
    this.deletePayment,
  }) : super(key: key);

  final loadingHandler;
  final insertPayment;
  final updatePayment;
  final deletePayment;
  final paymentData;
  @override
  _InputPaymentState createState() => _InputPaymentState();
}

class _InputPaymentState extends State<InputPayment> {
  bool _isIncome = false;
  String _price = '';

  @override
  void initState() {
    super.initState();
    if(widget.paymentData != null) {
      setState(() {
        _isIncome = widget.paymentData['isIncome'];
        _price = "${widget.paymentData['price']}";
      });
    }
  }

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

  void _deletePayment(id) async {
    widget.loadingHandler(true);
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final res = await KakeiboServerClient.deletePayment(token, id);
    widget.loadingHandler(false);
    if (res['status'] == 200) {
      widget.deletePayment(id);
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
            content: const Text('削除しました。'),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
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
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _submitValue() async {
    widget.loadingHandler(true);
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final res = widget.paymentData == null ?
      await KakeiboServerClient.createPayment(token, int.parse(_price), _isIncome)
      : await KakeiboServerClient.updatePayment(token, widget.paymentData['id'], int.parse(_price), _isIncome);
    widget.loadingHandler(false);
    if (res['status'] == 200) {
      if(widget.paymentData == null) {
        widget.insertPayment({
          'id': res['id'],
          'is_income': _isIncome,
          'price': int.parse(_price),
          'created_at': DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
        });
      }else{
        widget.updatePayment(
          widget.paymentData['id'],
          {
            'id': widget.paymentData['id'],
            'is_income': _isIncome,
            'price': int.parse(_price),
            'created_at': DateFormat('yyyy-MM-ddThh:mm:ss').format(DateTime.now()),
          }
        );
      }
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
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                  if(widget.paymentData != null) {
                    Navigator.pop(context);
                  }
                },
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
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                  if(widget.paymentData != null) {
                    Navigator.pop(context);
                  }
                },
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
                  controller: TextEditingController(text: _price),
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
          ),
          if(widget.paymentData != null) TextButton(
            onPressed: () {
              _deletePayment(widget.paymentData['id']);
            },
            child: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.red,
            ),
          )
        ]
      ),
    );
  }
}