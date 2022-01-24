import 'package:flutter/material.dart';

class IndexPayments extends StatefulWidget {
  IndexPayments({
    Key? key,
    required this.payments,
    required this.getPayments
  }) : super(key: key);

  List payments;
  final getPayments;
  @override
  _IndexPayments createState() => _IndexPayments();
}

class _IndexPayments extends State<IndexPayments> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: FloatingActionButton(
            onPressed: () async {
              await widget.getPayments();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.replay),
          ),
        ),
        Column(
          children: widget.payments != [] ? widget.payments.map((v) =>
            ListTile(
              title: Text(
                v['is_income'] ? "収入 ¥${v['price']}" : "支出 ¥${v['price']}",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 21,
                  color: v['is_income'] ? Colors.green : Colors.red
                ),
              ),
            )
          ).toList():
          <Widget>[const Text('Loading now...')],
        ),
      ],
    );
  }
}