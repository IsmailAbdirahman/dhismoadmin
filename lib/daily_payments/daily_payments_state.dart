import 'package:dhismoappadmin/add_new_project/add_new_project_state.dart';
import 'package:dhismoappadmin/models/daily_payments_model.dart';
import 'package:dhismoappadmin/service/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    print(" :::::: getDailyPaymentStream() :::: $projectID}");

    return Service(projectID: projectID).getDailyPaymentStream();
  }
}
