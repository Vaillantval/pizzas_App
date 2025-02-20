/*
import 'package:flutter/material.dart';
import 'moncash_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moncash Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const MonCashPayment(
      isStaging: true,
      amount: 100,
      clientId: "d229362b54d1cced4f55ef25d37a2603",
      clientSecret:
      "-1h4EkrL2zJ_oNW2Jn5Czv71NWVeL80ByeUrp-z2rQLPJV9uFSdq235Q38u4p-vq",
      loadingWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 30),
          Text("Redirecting to payment gateway..."),
        ],
      ),
    );
  }
}
*/