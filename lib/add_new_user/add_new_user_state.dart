import 'package:dhismoappadmin/add_new_project/add_new_project_state.dart';
import 'package:dhismoappadmin/models/history_model.dart';
import 'package:dhismoappadmin/models/users_model.dart';
import 'package:dhismoappadmin/productsListScreen/product_list_screen_state.dart';

import 'package:dhismoappadmin/service/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addingNewUserProvider = ChangeNotifierProvider<AddNewUserState>((ref) {
  final currentProjectName =
      ref.watch(addNewProjectProvider).currentProjectName;
  return AddNewUserState(projectID: currentProjectName);
});

//--
class AddNewUserState extends ChangeNotifier {
  AddNewUserState({this.projectID});

  Service _service = Service();
  bool _isBlocked = false;
  String? _userID;
  String? projectID;

  String? get userID => _userID;

  bool get isBlocked => _isBlocked;

  void getUserID(String user) {
    _userID = user;
    notifyListeners();
  }

  addNewUser(String phoneNumber, bool isBlocked, String projectID) async {
    return await _service.addNewUser(phoneNumber, isBlocked, projectID);
  }

  userStatus() {
    _isBlocked = !_isBlocked;
    // notifyListeners();
  }

  blockUnblockUser(String phoneNumber, bool isBlocked) async {
    Service(projectID: projectID).blockUnblockUser(phoneNumber, isBlocked);
    notifyListeners();
  }

  deleteAllData() {
    _service.deleteAllData();
  }

  Stream<List<UserInfo>> getPhoneNumberStream(String projectID) {
    return Service()
        .projects
        .doc(projectID)
        .collection('users')
        .snapshots()
        .map(Service().getPhoneNumberSnapshot);
  }

  Stream<List<HistoryModel>> getHistoryStreamm(String userID) {
    return _service.getHistoryStream(userID,projectID!);
  }
}
