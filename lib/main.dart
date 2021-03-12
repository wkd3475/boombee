import 'dart:async';

import 'package:boombee/screens/alert_page.dart';
import 'package:boombee/screens/category_page.dart';
import 'package:boombee/screens/historical_data_page.dart';
import 'package:boombee/screens/notice_page.dart';
import 'package:boombee/screens/park_info_page.dart';
import 'package:boombee/screens/park_list_page.dart';
import 'package:boombee/screens/home_page.dart';
import 'package:boombee/screens/my_page.dart';
import 'package:boombee/screens/search_page.dart';
import 'package:boombee/screens/subscribe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'loading.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Timer.periodic(Duration(minutes: 1), (Timer t) => _showNotification());
  runApp(MyApp());
}

Future<void> _showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    styleInformation: BigTextStyleInformation("여의도 한강공원 오후 2시 기준 인구 밀집도 82%, 사람 간 평균 거리 10m입니다.\n여의도 한강공원 오후 2시 기준 인구 밀집도 82%, 사람 간 평균 거리 10m입니다.\n여의도 한강공원 오후 2시 기준 인구 밀집도 82%, 사람 간 평균 거리 10m입니다.\n여의도 한강공원 오후 2시 기준 인구 밀집도 82%, 사람 간 평균 거리 10m입니다.")
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      '붐비',
      '공원 알림이 도착했습니다.',
      platformChannelSpecifics,
      payload: 'item x');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/MainPage': (context) => MainPage(),
        '/SearchPage': (context) => SearchPage(),
        '/ParkListPage': (context) =>
            ParkListPage(guId: ModalRoute.of(context).settings.arguments),
        '/ParkInfoPage': (context) =>
            ParkInfoPage(park: ModalRoute.of(context).settings.arguments),
        '/HistoricalDataPage': (context) =>
            HistoricalDataPage(park: ModalRoute.of(context).settings.arguments),
        '/AlertPage': (context) => AlertPage(),
        '/NoticePage': (context) => NoticePage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _currentIndex = 0;
  double circleSize = 50.0;
  double circlePaddingSize = 10.0;

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
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 10.0),
        height: 100.0,
        decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ]),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: _currentIndex == 0
                  ? Container(
                      height: circleSize,
                      decoration: BoxDecoration(
                        color: Color(0xCCFF9300),
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1.0,
                          color: Color(0xCCFF9300),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(circlePaddingSize),
                        child: Image.asset(
                          'assets/images/home_white.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      child: Container(
                        height: circleSize,
                        child: Container(
                          padding: EdgeInsets.all(circlePaddingSize),
                          child: Image.asset(
                            'assets/images/home_white.png',
                            color: Colors.black45,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ),
            ),
            Expanded(
              flex: 1,
              child: _currentIndex == 1
                  ? Container(
                      height: circleSize,
                      decoration: BoxDecoration(
                        color: Color(0xCCFF9300),
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1.0,
                          color: Color(0xCCFF9300),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(circlePaddingSize),
                        child: Image.asset(
                          'assets/images/map_icon.png',
                          color: Colors.white,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 1;
                        });
                      },
                      child: Container(
                        height: circleSize,
                        child: Container(
                          padding: EdgeInsets.all(circlePaddingSize),
                          child: Image.asset(
                            'assets/images/map_icon.png',
                            color: Colors.black45,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ),
            ),
            Expanded(
              flex: 1,
              child: _currentIndex == 2
                  ? Container(
                      height: circleSize,
                      decoration: BoxDecoration(
                        color: Color(0xCCFF9300),
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1.0,
                          color: Color(0xCCFF9300),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(circlePaddingSize),
                        child: Image.asset(
                          'assets/images/heart_white_icon.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 2;
                        });
                      },
                      child: Container(
                        height: circleSize,
                        child: Container(
                          padding: EdgeInsets.all(circlePaddingSize),
                          child: Image.asset(
                            'assets/images/heart_white_icon.png',
                            color: Colors.black45,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ),
            ),
            Expanded(
              flex: 1,
              child: _currentIndex == 3
                  ? Container(
                      height: circleSize,
                      decoration: BoxDecoration(
                        color: Color(0xCCFF9300),
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1.0,
                          color: Color(0xCCFF9300),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(circlePaddingSize),
                        child: Image.asset(
                          'assets/images/man_icon.png',
                          color: Colors.white,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 3;
                        });
                      },
                      child: Container(
                        height: circleSize,
                        child: Container(
                          padding: EdgeInsets.all(circlePaddingSize),
                          child: Image.asset(
                            'assets/images/man_icon.png',
                            color: Colors.black45,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
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
