import 'package:dhismoappadmin/widgets/bottom_navigation_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_new_project/add_new_project.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: AddNewProject());
  }
}

///TODO:1- Test the user app if it can login different id with different projects
///TODO:2- Find new way to save the new projects
///TODO:3- First page of admin app and user app show list of projects saved
///TODO:4- Delete the features that not needed in the project
///TODO:5- Change the color of both apps
