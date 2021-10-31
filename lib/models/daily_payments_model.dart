import 'package:cloud_firestore/cloud_firestore.dart';

class DailyPaymentsModel {
  String? paymentID;
  String? name;
  Timestamp? date;
  double? amount;

  DailyPaymentsModel({this.paymentID, this.name, this.date, this.amount});
}
