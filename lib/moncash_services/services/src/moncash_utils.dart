
/*
import 'dart:developer';

import 'package:dio/dio.dart';

class MonCash {
  final String clientId;
  final String clientSecret;

  final bool staging;
  MonCash({this.staging = false, required this.clientId, required this.clientSecret});

  // String get authHeader => 'Basic ' + clientId + ':' + clientSecret;
  String get hostRestApi =>
      staging ? "sandbox.moncashbutton.digicelgroup.com/Api" : "moncashbutton.digicelgroup.com/Api";

  String get gatewayBaseUrl => staging
      ? "https://sandbox.moncashbutton.digicelgroup.com/Moncash-middleware"
      : "https://moncashbutton.digicelgroup.com/Moncash-middleware";

  String get oauthUrl {
    return "https://$clientId:$clientSecret@$hostRestApi/oauth/token";
  }

  String get paymentUrl {
    return "https://$hostRestApi/v1/CreatePayment";
  }

  String get paymentRedirectUrl {
    return "$gatewayBaseUrl/Payment/Redirect?token=";
  }

  String get retrieveTransactionPaymentUrl {
    return "https://$hostRestApi/v1/RetrieveTransactionPayment";
  }

  String get retrieveOrderPaymentUrl {
    return "https://$hostRestApi/v1/RetrieveOrderPayment";
  }

  Future<String?> getWebviewUrl({required String amount, required String orderId}) async {
    String? oAuth = await generateOauthToken();
    if (oAuth != null) {
      return await generatePaymentUrl(oAuth, amount: amount, orderId: orderId);
    } else {
      return null;
    }
  }

  Future<String?> generateOauthToken() async {
    //? Generating Oauth Token for MonCash
    Dio dio = Dio()
      ..options.headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      };
    // //dio.interceptors.add(PrettyDioLogger());
    try {
      var resp = await dio.post(oauthUrl, data: {
        "scope": "read",
        "grant_type": "client_credentials",
      });
      if (resp.data["access_token"] != null) {
        log(resp.data["access_token"]);
        return resp.data["access_token"];
      }
    } catch (e) {
      if (e is DioError) {
        log(e.response.toString());
      } else {
        log(e.toString());
      }
    }
    return null;
  }

  Future<String?> generatePaymentUrl(String authToken, {required String amount, required String orderId}) async {
    //? Genrerating Payment Url that can we used to show a webview

    String url = paymentUrl;
    Dio dio = Dio()
      ..options.headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      };

    //dio.interceptors.add(PrettyDioLogger());

    try {
      var resp = await dio.post(url, data: {"amount": amount, "orderId": orderId});
      log(resp.data.toString());
      if (resp.data["payment_token"]["token"] != null) {
        var payToken = resp.data["payment_token"]["token"];
        var payUrl = paymentRedirectUrl + payToken;
        return payUrl;
      }
    } catch (e) {
      if (e is DioError) {
        log(e.response.toString());
      } else {
        log(e.toString());
      }
      return null;
    }
  }

  retrieveTransanction(String transanctionId) async {
    String? oAuth = await generateOauthToken();
    if (oAuth != null) {
      return await retrieveTransactionPayment(transanctionId /*"2170901316"*/, oAuth);
    } else {
      return null;
    }
  }

  retrieveOrder(String orderId) async {
    String? oAuth = await generateOauthToken();
    if (oAuth != null) {
      return await retrieveOrderPayment(orderId, oAuth);
    } else {
      return null;
    }
  }

  Future retrieveTransactionPayment(String transanctionId, String oauth) async {
    //? To retrieve payment details after payment is successfull

    String url = retrieveTransactionPaymentUrl;
    Dio dio = Dio()
      ..options.headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $oauth",
      };
    //dio.interceptors.add(PrettyDioLogger());
    try {
      var resp = await dio.post(url, data: {"transactionId": transanctionId});
      log(resp.data.toString());
      return resp.data;
    } catch (e) {
      if (e is DioError) {
        log(e.response.toString());
      } else {
        log(e.toString());
      }
    }
  }

  retrieveOrderPayment(String orderId, String oauth) async {
    //? To retrieve payment details after payment is successfull

    String url = retrieveOrderPaymentUrl;
    Dio dio = Dio()
      ..options.headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $oauth",
      };
    //dio.interceptors.add(PrettyDioLogger());
    try {
      var resp = await dio.post(url, data: {"orderId": orderId});
      log(resp.data.toString());
      return resp.data;
    } catch (e) {
      if (e is DioError) {
        log(e.response.toString());
      } else {
        log(e.toString());
      }
    }
  }
}
*/