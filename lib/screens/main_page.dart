import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/cart_page.dart';
import 'package:login/screens/home.dart';
import 'package:login/screens/more_page.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  Widget _widget = Home();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B47A9),
      ),
      body: _widget,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label:""),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label:""),
          BottomNavigationBarItem(icon: Icon(Icons.more), label:""),
        ],
        onTap: onTap,
        currentIndex: currentIndex,
      ),
    );
  }

  void onTap(int x) {
    currentIndex = x;
    if(currentIndex == 0) {
      _widget = Home();
    } else if (currentIndex == 1) {
      _widget =CartPage(true);
    } else {
      _widget = MoreScreen();
    }
    setState(() {});
  }
}
