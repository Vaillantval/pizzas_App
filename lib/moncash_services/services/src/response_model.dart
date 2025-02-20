enum paymentStatus { success, failed }

class PaymentResponse {
  String? transanctionId;
  paymentStatus status;
  String? message;
  String? orderId;

  PaymentResponse({this.transanctionId, required this.status, required this.message, this.orderId});
}
