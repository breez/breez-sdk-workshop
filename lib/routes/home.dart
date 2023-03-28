import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sdkwallet/routes/send.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breez SDK Demo'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Send button
            Expanded(
              child: TextButton(
                //'Receive'
                onPressed: () async {
                  Navigator.of(context).pushNamed("/receive");
                },
                child: const Text('Receive', style: TextStyle(color: Colors.white)),
              ),
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.white,
            ),

            // Receive button
            Expanded(
              child: TextButton(
                //'Receive'
                onPressed: () async {
                  final sdkBridge = context.read<BreezBridge>();
                  final scannedData = await Navigator.of(context).pushNamed('/scan');
                  if (scannedData != null && scannedData is String) {
                    final parsedInput = await sdkBridge.parseInput(input: scannedData);
                    if (mounted) {
                      if (parsedInput is InputType_Bolt11) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SendPaymentDialog(invoice: parsedInput.invoice);
                            });
                      }
                    }
                  }
                },

                child: const Text('Scan', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomBarActionButton extends StatelessWidget {
  const BottomBarActionButton({super.key, required this.onPressed, required this.text});

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
