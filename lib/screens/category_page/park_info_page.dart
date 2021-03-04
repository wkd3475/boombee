import 'package:boombee/services/github_api/get_parks_info.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ParkInfoPage extends StatefulWidget {
  final Park park;

  ParkInfoPage({@required this.park});

  @override
  _ParkInfoPageState createState() => _ParkInfoPageState();
}

class _ParkInfoPageState extends State<ParkInfoPage> {
  Park _park;
  Position _position;

  int _currentState = 0;
  bool _isLocationServiceEnabled = true;
  bool _isTimeLimited = false;

  Widget appBarTitle() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      height: 85,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFFF),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                "assets/images/left_arrow.png",
                width: 35,
                height: 35,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              child: Text('공원 정보',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF707070))),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {},
                child: Image.asset(
                  "assets/images/simple_alert.png",
                  width: 35,
                  height: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mapBox() {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height * 2 / 5;

    if (_currentState == 0) {
      return Container(
        color: Color(0xFFF5F5F5),
        width: widthSize,
        height: heightSize,
        child: Center(
          child: SizedBox(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (!_isLocationServiceEnabled) {
      return Container(
        color: Color(0xFFF5F5F5),
        width: widthSize,
        height: heightSize,
        child: Center(
          child: Text(
            "GPS가 활성화되지 않았습니다.",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    if (_isTimeLimited) {
      return Container(
        color: Color(0xFFF5F5F5),
        width: widthSize,
        height: heightSize,
        child: Center(
          child: Text(
            "위치 정보를 불러오지 못했습니다.",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    return Container(
      width: widthSize,
      height: heightSize,
      child: Text(_currentState.toString()),
    );
  }

  Widget infoBox() {
    return Expanded(child: Text(_park.id));
  }

  @override
  void initState() {
    super.initState();
    _park = widget.park;
    asyncMethods();
  }

  void asyncMethods() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      try {
        _position = await Geolocator.getCurrentPosition(
            timeLimit: Duration(seconds: 2),
            desiredAccuracy: LocationAccuracy.high
        );
        _isTimeLimited = false;
      } catch (e) {
        _isTimeLimited = true;
      }
    } else {
      _isLocationServiceEnabled = false;
    }

    if (mounted) {
      setState(() {
        _currentState = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            appBarTitle(),
            mapBox(),
            infoBox(),
          ],
        ),
      ),
    );
  }
}