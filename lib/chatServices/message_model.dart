import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String message;
  final Timestamp timestamp;
  final String receverID;
  final String name;

  Message(
      {required this.timestamp,
      required this.message,
      required this.senderID,
      required this.senderEmail,
      required this.receverID,
      required this.name});

  // convert
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receverID,
      'timestamp': timestamp,
      'message': message,
      'name': name,
    };
  }
}
