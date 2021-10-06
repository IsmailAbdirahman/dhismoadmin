import 'package:flutter/material.dart';

class AddNewProject extends StatelessWidget {
  TextEditingController _projectNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _projectNameController,
          ),
          ElevatedButton(onPressed: () {

          }, child: Text("Add New Project"))
        ],
      ),
    );
  }
}
