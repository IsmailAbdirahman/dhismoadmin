import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhismoappadmin/add_new_project/add_new_project_state.dart';
import 'package:dhismoappadmin/models/daily_payments_model.dart';
import 'package:dhismoappadmin/service/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final dailyPaymentsProvider = ChangeNotifierProvider<DailyPaymentsState>((ref) {
  final projectID = ref.watch(addNewProjectProvider).currentProjectName;
  return DailyPaymentsState(projectID: projectID);
});

class DailyPaymentsState extends ChangeNotifier {
  DailyPaymentsState({this.projectID});

  String? projectID;
  Service _service = Service();

  saveTodayPayment(String name, double amount) {
    return Service(projectID: projectID).saveTodayPayment(name, amount);
  }

  deletePayment(String id) {
    return Service(projectID: projectID).deletePayment(id);
  }

  Stream<List<DailyPaymentsModel>> getDailyPaymentStream() {
    return Service(projectID: projectID).getDailyPaymentStream();
  }

  String convertTimeStamp(Timestamp timestamp) {
    String convertedDate;
    convertedDate = DateFormat.yMd().add_jm().format(timestamp.toDate());
    return convertedDate.split(" ")[0];
  }
}
