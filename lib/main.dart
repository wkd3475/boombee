import 'dart:async';
import 'dart:convert';

import 'package:boombee/screens/category_page/category_page.dart';
import 'package:boombee/screens/category_page/park_list_page.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/MainPage': (context) => MainPage(),
        '/ParkListPage': (context) => ParkListPage(guId: ModalRoute.of(context).settings.arguments),
      },
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

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      ),
    );
    loading();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFF9300),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
              width: width,
              height: height * 0.65,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                // backgroundColor: Color(0xFFFF9300),
                body: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Image.asset(
                      'assets/images/boombee_title.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
              width: width,
              height: height,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                // backgroundColor: Color(0xFFFF9300),
                body: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Image.asset(
                      'assets/images/density_level_2.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
