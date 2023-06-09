import 'package:breez_sdk/breez_bridge.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sdkwallet/routes/home.dart';
import 'package:sdkwallet/routes/receive.dart';
import 'package:sdkwallet/routes/scan.dart';
import 'package:sdkwallet/sdk_bridge.dart';

void main() {
  Fimber.plantTree(DebugTree());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => BreezBridge()..start(),
      lazy: false,
      child: MaterialApp(
        home: const HomePage(),
        routes: {
          '/receive': (ctx) => const ReceivePage(),
          '/scan': (ctx) => const QRScan(),
        },
      ),
    );
  }
}
