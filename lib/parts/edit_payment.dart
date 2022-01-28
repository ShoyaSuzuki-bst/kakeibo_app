import 'package:flutter/material.dart';
import 'package:kakeibo_app/pages/input_payment.dart';

class EditPayment extends StatelessWidget {
  EditPayment({
    Key? key,
    required this.payments,
    required this.loadingHandler,
    required this.paymentData,
    this.insertPayment,
  }) : super(key: key);

  List payments;
  final paymentData;
  final loadingHandler;
  final insertPayment;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('収支編集')
      ),
      body: InputPayment(
        loadingHandler: loadingHandler,
        insertPayment: insertPayment,
        paymentData: paymentData,
      ),
    );
  }
}