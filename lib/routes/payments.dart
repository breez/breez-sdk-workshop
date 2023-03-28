import 'dart:io';

import 'package:flutter/material.dart';
import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:intl/intl.dart';

class PaymentsList extends StatelessWidget {
  const PaymentsList({super.key, required this.payments});
  final List<sdk.Payment> payments;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          final bool sent = payment.paymentType == sdk.PaymentType.Sent;
          return ListTile(
            leading: Icon(sent ? Icons.remove : Icons.add),
            title: Text(payment.description?.isNotEmpty == true ? payment.description! : 'Unknown'),
            subtitle: Text(DateFormat.yMd(Platform.localeName)
                .format(DateTime.fromMillisecondsSinceEpoch(payment.paymentTime * 1000))),
            trailing: Text('${(payment.amountMsat / 1000).toStringAsFixed(0)} sats'),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 3,
            color: Colors.grey[350],
          );
        });
  }
}
