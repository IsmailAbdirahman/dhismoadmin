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
          primarySwatch: Colors.deepOrange,
        ),
        home: AddNewProject());
  }
}

///TODO:1- Change Titles
///TODO:2- Change color
///TODO:3- Test full apps
///TODO:4- Show the apps to bukhaari
///TODO:5- Start building the last feature
