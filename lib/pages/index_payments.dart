import 'package:flutter/material.dart';

class IndexPayments extends StatefulWidget {
  IndexPayments({
    Key? key,
    required this.payments,
    required this.getPayments,
    required this.loadingHandler,
  }) : super(key: key);

  List payments;
  final getPayments;
  final loadingHandler;
  @override
  _IndexPayments createState() => _IndexPayments();
}

class _IndexPayments extends State<IndexPayments> {
  Widget _paymentItem(int price, bool isIncome) {
    return GestureDetector(
      child:Container(
        padding: const EdgeInsets.all(15.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.grey)
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'yyyy/mm/dd hh:mm',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              isIncome ? "+ ¥$price" : "- ¥$price",
              style: TextStyle(
                color: isIncome ? Colors.blue : Colors.red,
                fontSize: 20,
              ),
            ),
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.getPayments();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: widget.payments != [] ? widget.payments.map((v) =>
          _paymentItem(v['price'], v['is_income'])
        ).toList():
        <Widget>[const Text('Loading now...')],
      ),
    );
  }
}