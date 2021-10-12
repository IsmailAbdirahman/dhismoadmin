import 'package:dhismoappadmin/models/project_names_or_ids.dart';
import 'package:dhismoappadmin/service/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addNewProjectProvider =
    ChangeNotifierProvider((ref) => AddNewProjectState());

//--
class AddNewProjectState extends ChangeNotifier {
  Service _service = Service();
  String? _currentProjectName;

  String? get currentProjectName => _currentProjectName;

  createProjectNameOrID(String projectNameOrID) {
    return _service.createProjectNameOrID(projectNameOrID);
  }

  getCurrentProjectName(String name) {
    _currentProjectName = name;
    notifyListeners();
  }

  Stream<List<ProjectsNames>> get getCreatedProjectNames {
    return _service.projects.snapshots().map(_service.getCreatedProjectsIDs);
  }

  deleteProjectName(String projectName) {
    return _service.deleteProjectName(projectName);
  }
}
