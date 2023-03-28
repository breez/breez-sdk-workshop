import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ReceivePageState();
  }
}

class ReceivePageState extends State<ReceivePage> {
  final _formKey = GlobalKey<FormState>();
  int amountSat = 0;
  String description = '';
  final bool _isLoading = false;
  LNInvoice? _invoice;

  @override
  void initState() {
    super.initState();
    final BreezBridge sdkBridge = context.read();
    sdkBridge.invoicePaidStream.listen((invoicePaidDetails) {
      if (invoicePaidDetails.paymentHash == _invoice?.paymentHash) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive'),
      ),
      body: _invoice != null ? showQRCode(_invoice!) : showInvoiceForm(),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final LNInvoice? invoice = await showDialog(
                          context: context,
                          builder: (context) {
                            return ReceivePaymentDialog(amountSat: amountSat, description: description);
                          });
                      if (invoice != null) {
                        setState(() {
                          _invoice = invoice;
                        });
                      }
                    }
                  },
            child: const Text('Receive'),
          ),
        ),
      ),
    );
  }

  Widget showInvoiceForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              onSaved: (value) {
                amountSat = int.parse(value!);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              onSaved: (value) {
                description = value!;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget showQRCode(LNInvoice invoice) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: AspectRatio(
            aspectRatio: 1,
            child: SizedBox(
              width: 230.0,
              height: 230.0,
              child: QrImage(
                data: invoice.bolt11,
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 16.0)),
        const Padding(padding: EdgeInsets.only(top: 16.0)),
      ],
    );
  }
}

class ReceivePaymentDialog extends StatefulWidget {
  const ReceivePaymentDialog({super.key, required this.description, required this.amountSat});
  final String description;
  final int amountSat;

  @override
  State<StatefulWidget> createState() {
    return ReceivePaymentDialogState();
  }
}

class ReceivePaymentDialogState extends State<ReceivePaymentDialog> {
  @override
  void initState() {
    super.initState();
    final BreezBridge sdkBridge = context.read();
    sdkBridge
        .receivePayment(amountSats: widget.amountSat, description: widget.description)
        .then((lnInvoice) => Navigator.of(context).pop(lnInvoice))
        .onError((error, stackTrace) => Navigator.of(context).pop(null));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // The background color
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
            Text('Creating invoice...')
          ],
        ),
      ),
    );
  }
}
