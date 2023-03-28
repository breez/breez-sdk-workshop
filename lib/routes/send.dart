import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter/material.dart';

class SendPaymentDialog extends StatefulWidget {
  const SendPaymentDialog({super.key, required this.invoice});
  final LNInvoice invoice;

  @override
  State<StatefulWidget> createState() {
    return SendPaymentDialogState();
  }
}

class SendPaymentDialogState extends State<SendPaymentDialog> {
  bool payInProgress = false;

  @override
  Widget build(BuildContext context) {
    return !payInProgress ? buildOkCancel() : buildInProgressPayment();
  }

  Widget buildOkCancel() {
    return AlertDialog(
      title: const Text("Send Payment"),
      content: Text("Are you sure you want to send ${widget.invoice.amountMsat! / 1000} Sats?"),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () {},
        ),
        TextButton(
          child: const Text("CANCEL"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Widget buildInProgressPayment() {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            // The loading indicator
            CircularProgressIndicator(),
            SizedBox(
              height: 15,
            ),
            // Some text
            Text('Sending payment...')
          ],
        ),
      ),
    );
  }
}
