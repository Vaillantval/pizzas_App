
/*
import 'dart:developer';

import 'package:flutter/material.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'moncash_utils.dart';
import 'response_model.dart';

class MonCashPayment extends StatefulWidget {
  final double amount;
  final String? orderId;
  final String clientId;
  final String clientSecret;
  final Widget? loadingWidget;
  final bool isStaging;
  const MonCashPayment(
      {required this.amount,
      this.orderId,
      required this.clientId,
      required this.clientSecret,
      this.loadingWidget,
      this.isStaging = false,
      Key? key})
      : super(key: key);

  @override
  _MonCashPaymentState createState() => _MonCashPaymentState();
}

class _MonCashPaymentState extends State<MonCashPayment> {
  late MonCash monCash;
  bool isLoading = true;
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();
  @override
  void initState() {
    monCash = MonCash(clientId: widget.clientId, clientSecret: widget.clientSecret, staging: widget.isStaging);
    if (widget.orderId != null) {
      orderId = widget.orderId!;
    }
    monCash.getWebviewUrl(amount: widget.amount.toString(), orderId: orderId).then((value) {
      if (value != null) {
        setState(() => paymentUrl = value);
      } else {
        Navigator.pop(
            context,
            PaymentResponse(
                status: paymentStatus.failed, message: "Error in generating token, Please try again later.."));
      }
    });
    super.initState();
  }

  String? paymentUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (paymentUrl != null)
            WebView(
              initialUrl: paymentUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (url) {
                setState(() {
                  isLoading = false;
                });

                log(url);
                //getting transanction id from moncash url
                if (url.contains('transactionId')) {
                  final transactionId = url.split('transactionId=')[1];
                  log('transactionId: $transactionId');
                  //   monCash.retrieveTransactionPayment(transactionId);
                  //  displaySnackBar("Payment Successfull $transactionId", context);
                  Navigator.pop(
                      context,
                      PaymentResponse(
                          transanctionId: transactionId,
                          orderId: orderId,
                          status: paymentStatus.success,
                          message: "Payment Successfull $transactionId"));
                }
                if (url.contains('error')) {
                  final errorData = url.split('error=');
                  String error = errorData.length > 1 ? errorData[1] : 'Error, Please Try Again Later';
                  log('error: $error');
                  Navigator.pop(
                      context, PaymentResponse(status: paymentStatus.failed, message: error, orderId: orderId));
                }
              },
            ),
          if (paymentUrl == null || isLoading)
            Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Center(child: widget.loadingWidget ?? const CircularProgressIndicator()))
        ],
      ),
    );
  }
}
*/