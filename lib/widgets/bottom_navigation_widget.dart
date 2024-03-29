import 'package:dhismoappadmin/add_new_project/add_new_project.dart';
import 'package:dhismoappadmin/add_new_user/add_new_user.dart';
import 'package:dhismoappadmin/daily_payments/daily_payments.dart';
import 'package:dhismoappadmin/productsListScreen/product_list_screen.dart';
import 'package:flutter/material.dart';

class DisplayData extends StatefulWidget {
  DisplayData({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeState();
  }
}

class homeState extends State<DisplayData> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    ProductsListScreen(),
    AddNewUser(),
    DailyPayments()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: getBottomNavigationBar());
  }

  Widget getBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.deepOrange,
      elevation: 0,
      unselectedItemColor: Colors.white70,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Users"),
        BottomNavigationBarItem(icon: Icon(Icons.payments_outlined), label: "Daily Payments"),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      onTap: _onItemTapped,
    );
  }
}
