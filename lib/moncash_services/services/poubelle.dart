/*import 'package:flutter/material.dart';

// Définir les classes PaymentStatus et PaymentResponse
enum PaymentStatus { success, failure }

class PaymentResponse {
  final PaymentStatus status;
  final String? transactionId;
  final String? orderId;
  final String? message;

  PaymentResponse({
    required this.status,
    this.transactionId,
    this.orderId,
    this.message,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaymentScreen(),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool paymentSuccess = false;
  bool isLoading = false;

  Future<void> initiateMonCashPayment() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PaymentResponse? data = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MonCashPayment(
                  isStaging: true,
                  amount: 1000,
                  // Montant en gourdes
                  clientId: "d229362b54d1cced4f55ef25d37a2603",
                  clientSecret:
                      "-1h4EkrL2zJ_oNW2Jn5Czv71NWVeL80ByeUrp-z2rQLPJV9uFSdq235Q38u4p-vq",
                  loadingWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Redirecting to payment gateway..."),
                    ],
                  ),
                )),
      );
      if (data != null &&
          data.status == PaymentStatus.success &&
          data.transactionId != null) {
        setState(() {
          paymentSuccess = true;
        });
        placeOrder(transactionId: data.transactionId!, orderId: data.orderId!);
      } else {
        if (data == null) {
          showErrorDialog(context, "ERROR: Payment Failed");
        } else {
          showErrorDialog(context, "ERROR: ${data.message}");
        }
        setState(() {
          isLoading = false;
          paymentSuccess = false;
        });
      }
    });
  }

  void placeOrder({required String transactionId, required String orderId}) {
    // Code to place the order
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MonCash Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            initiateMonCashPayment();
          },
          child: Text('Pay with MonCash'),
        ),
      ),
    );
  }
}

class MonCashPayment extends StatelessWidget {
  final bool isStaging;
  final int amount;
  final String clientId;
  final String clientSecret;
  final Widget loadingWidget;

  MonCashPayment({
    required this.isStaging,
    required this.amount,
    required this.clientId,
    required this.clientSecret,
    required this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Simulating a payment process
    return Scaffold(
      appBar: AppBar(
        title: Text('MonCash Payment Processing'),
      ),
      body: Center(
        child: loadingWidget,
      ),
    );
  }
}

////---------------------------------------------\
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

enum PaymentStatus { success, failure }

class PaymentResponse {
  final PaymentStatus status;
  final String? transactionId;
  final String? orderId;
  final String? message;

  PaymentResponse({
    required this.status,
    this.transactionId,
    this.orderId,
    this.message,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaymentScreen(),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool paymentSuccess = false;
  bool isLoading = false;

  Future<String> getMonCashToken(String clientId, String clientSecret) async {
    final response = await http.post(
      Uri.parse(
          'https://sandbox.moncashbutton.digicelgroup.com/Api/oauth/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'scope': 'read,write',
        'grant_type': 'client_credentials',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to obtain access token');
    }
  }

  Future<PaymentResponse> createMonCashPayment(String token, int amount) async {
    final response = await http.post(
      Uri.parse(
          'https://sandbox.moncashbutton.digicelgroup.com/Api/v1/CreatePayment'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'amount': amount,
        'orderId': '123456',
        // Utilisez un identifiant unique pour chaque commande
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaymentResponse(
        status: PaymentStatus.success,
        transactionId: data['payment_token']['token'],
        orderId: '123456', // Réutilisez l'identifiant unique de la commande
        message: 'Payment created successfully',
      );
    } else {
      final data = jsonDecode(response.body);
      return PaymentResponse(
        status: PaymentStatus.failure,
        message: data['message'],
      );
    }
  }

  Future<void> initiateMonCashPayment() async {
    setState(() {
      isLoading = true;
    });

    try {
      final token = await getMonCashToken("d229362b54d1cced4f55ef25d37a2603",
          '-1h4EkrL2zJ_oNW2Jn5Czv71NWVeL80ByeUrp-z2rQLPJV9uFSdq235Q38u4p-vq');
      final paymentResponse = await createMonCashPayment(token, 1000);

      if (paymentResponse.status == PaymentStatus.success) {
        setState(() {
          paymentSuccess = true;
        });

        final redirectUrl =
            'https://sandbox.moncashbutton.digicelgroup.com/Moncash-middleware/Payment/Redirect?token=${paymentResponse.transactionId}';
        if (await canLaunchUrl(Uri.parse(redirectUrl))) {
          await launchUrl(Uri.parse(redirectUrl));
        } else {
          throw 'Could not launch $redirectUrl';
        }
      } else {
        showErrorDialog(context, "ERROR: ${paymentResponse.message}");
      }
    } catch (e) {
      showErrorDialog(context, "ERROR: Payment Failed\n \n $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void placeOrder({required String transactionId, required String orderId}) {
    // Exemple de traitement de la commande après le paiement réussi
    print('Order placed successfully!');
    print('Transaction ID: $transactionId');
    print('Order ID: $orderId');
    // Ajoutez ici le code pour enregistrer la commande dans votre base de données
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MonCash Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            initiateMonCashPayment();
          },
          child: const Text('Pay with MonCash'),
        ),
      ),
    );
  }
}

*/