import 'package:dhismoappadmin/models/history_model.dart';
import 'package:dhismoappadmin/models/users_model.dart';
import 'package:dhismoappadmin/productsListScreen/product_list_screen_state.dart';

import 'package:dhismoappadmin/service/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addingNewUserProvider =
    ChangeNotifierProvider((ref) => AddNewUserState());

//--
class AddNewUserState extends ChangeNotifier {
  Service _service = Service();
  bool _isBlocked = false;
  String? _userID;

  String? get userID => _userID;

  bool get isBlocked => _isBlocked;

  void getUserID(String user) {
    _userID = user;
    notifyListeners();
  }

  addNewUser(String phoneNumber, bool isBlocked) async {
    return await _service.addNewUser(phoneNumber, isBlocked);
  }

  userStatus() {
    _isBlocked = !_isBlocked;
    // notifyListeners();
  }

  blockUnblockUser(String phoneNumber, bool isBlocked) async {
    _service.blockUnblockUser(phoneNumber, isBlocked);
    notifyListeners();
  }

  deleteAllData() {
    _service.deleteAllData();
  }

  Stream<List<UserInfo>> get getPhoneNumberStream {
    return Service()
        .projects
        .doc(projectID)
        .collection('users')
        .snapshots()
        .map(Service().getPhoneNumberSnapshot);
  }

  Stream<List<HistoryModel>> getHistoryStreamm(String userID) {
    return _service.getHistoryStream(userID);
  }
}
