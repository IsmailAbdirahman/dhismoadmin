import 'package:dhismoappadmin/models/project_names_or_ids.dart';
import 'package:dhismoappadmin/productsListScreen/product_list_screen.dart';
import 'package:dhismoappadmin/widgets/bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'add_new_project_state.dart';

class AddNewProject extends ConsumerWidget {
  TextEditingController _projectNameController = TextEditingController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final newUserProvider = watch(addNewProjectProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Project List"),
        centerTitle: true,
      ),
      body: (Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(38.0),
              child: TextField(
                maxLength: 10,
                controller: _projectNameController,
                decoration: InputDecoration(
                  hintText: "Enter new project name",
                ),
              )),
          TextButton(
              onPressed: () async {
                await context
                    .read(addNewProjectProvider)
                    .createProjectNameOrID(_projectNameController.text);
                _projectNameController.clear();
                FocusScope.of(context).unfocus();
              },
              child: Text("Create")),
          Expanded(
            child: StreamBuilder<List<ProjectsNames>>(
                stream: newUserProvider.getCreatedProjectNames,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    var projectNameList = snapshot.data;
                    return ListView.builder(
                        itemCount: projectNameList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                context
                                    .read(addNewProjectProvider)
                                    .getCurrentProjectName(
                                        projectNameList[index].projectName!);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DisplayData()));
                              },
                              title: Text(projectNameList[index].projectName!),
                              subtitle: Divider(),
                              trailing: InkWell(
                                onTap: () {
                                  newUserProvider.deleteProjectName(
                                      projectNameList[index].projectName!);
                                },
                                child: Icon(
                                  Icons.delete_forever_outlined,
                                ),
                              ),
                            ),
                          );
                        });
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          ),
        ],
      )),
    );
  }
}
