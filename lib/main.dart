import 'package:breez_sdk/breez_bridge.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sdkwallet/routes/home.dart';

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
      create: (context) => BreezBridge(),
      lazy: false,
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
