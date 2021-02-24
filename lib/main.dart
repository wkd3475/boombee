import 'dart:convert';

import 'package:boombee/screens/category_page/category_page.dart';
import 'package:boombee/screens/home_page/home_page.dart';
import 'package:boombee/screens/my_page/my_page.dart';
import 'package:boombee/screens/subscribe_page/subscribe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'loading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _currentIndex = 0;

  final List<Widget> _children = [
    HomePage(),
    CategoryPage(),
    SubscribePage(),
    MyPage(),
  ];

  @override
  void initState() {
    super.initState();
    loading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.black26,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'subscribe',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'my',
            ),
          ]),
    );
  }
}

