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
      padding: EdgeInsets.only(top: 20.0),
      height: 105,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(0xFFFFFFFFF),
          border: Border(
              bottom: BorderSide(
            width: 1.5,
            color: Color(0xFFD9D9D9),
          ))),
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

    if (_currentState == 0) {
      return Expanded(
        child: Container(
          color: Color(0xFFF5F5F5),
          width: widthSize,
          child: Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }

    if (!_isLocationServiceEnabled) {
      return Expanded(
        child: Container(
          color: Color(0xFFF5F5F5),
          width: widthSize,
          child: Center(
            child: Text(
              "GPS가 활성화되지 않았습니다.",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      );
    }

    if (_isTimeLimited) {
      return Expanded(
        child: Container(
          color: Color(0xFFF5F5F5),
          width: widthSize,
          child: Center(
            child: Text(
              "위치 정보를 불러오지 못했습니다.",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Container(
        width: widthSize,
        child: Text(_position.toString()),
      ),
    );
  }

  Widget densityImage(double density) {
    double size = 120;

    if (density >= 0.0 && density < 30.0) {
      return Image.asset(
        'assets/images/density_level_1.png',
        width: size,
        height: size,
      );
    } else if (density >= 30.0 && density < 60.0) {
      return Image.asset(
        'assets/images/density_level_2.png',
        width: size,
        height: size,
      );
    } else if (density >= 60.0 && density < 80.0) {
      return Image.asset(
        'assets/images/density_level_3.png',
        width: size,
        height: size,
      );
    } else {
      return Image.asset(
        'assets/images/density_level_4.png',
        width: size,
        height: size,
      );
    }
  }

  Widget parkMainInfoBox() {
    double bigFontSize = 20.0;
    double smallFontSize = 13.0;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFFF),
        border: Border(
          bottom: BorderSide(
            width: 1.5,
            color: Color(0xFFD9D9D9),
          ),
          top: BorderSide(
            width: 1.5,
            color: Color(0xFFD9D9D9),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Container(
              margin: EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 3.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _park.name,
                      style: TextStyle(
                        fontSize: bigFontSize,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _park.location,
                      style: TextStyle(
                        fontSize: smallFontSize,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ),
                  Container(height: 10.0),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xCCFF9300),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 15.0,
                          ),
                          Container(
                              width: 120.0,
                              child: Text(
                                "인구 밀집도 : ${_park.getLatestDensity().toStringAsFixed(1)}%",
                                style: TextStyle(
                                  fontSize: smallFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFFFFF),
                                ),
                              )),
                          Container(
                            child: Text(
                              "사람 간 평균 거리 : ${_park.getLatestAverageDistance().toStringAsFixed(1)}m",
                              style: TextStyle(
                                fontSize: smallFontSize,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
                alignment: Alignment.centerLeft,
                child: densityImage(_park.getLatestDensity())),
          ),
        ],
      ),
    );
  }

  Widget parkDetailInfoBox() {
    double bigFontSize = 20.0;
    double smallFontSize = 15.0;
    double buttonWidth = 120;

    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(23.0),
        color: Color(0xFFFFFFFF),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Text(
                  "공원 정보",
                  style: TextStyle(
                    fontSize: bigFontSize,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB5B5B5),
                  ),
                ),
              ],
            ),
            Container(height: 5.0),
            Row(
              children: [
                Text(
                  "전화: ",
                  style: TextStyle(
                    fontSize: smallFontSize,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB5B5B5),
                  ),
                ),
                Text(
                  "${_park.telephone}",
                  style: TextStyle(
                    fontSize: smallFontSize,
                    color: Color(0xFFB5B5B5),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "운영 시간: ",
                  style: TextStyle(
                    fontSize: smallFontSize,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB5B5B5),
                  ),
                ),
                Text(
                  "${_park.hour}",
                  style: TextStyle(
                    fontSize: smallFontSize,
                    color: Color(0xFFB5B5B5),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "홈페이지: ",
                  style: TextStyle(
                    fontSize: smallFontSize,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB5B5B5),
                  ),
                ),
                Text(
                  "${_park.website}",
                  style: TextStyle(
                    fontSize: smallFontSize,
                    color: Color(0xFFB5B5B5),
                  ),
                ),
              ],
            ),
            Container(height: 20.0),
            Row(
              children: [
                Container(
                  height: 40,
                  width: buttonWidth,
                  decoration: BoxDecoration(
                    color: Color(0xCCFF9300),
                    border: Border.all(
                      color: Color(0xFFFF9300),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/heart_white_icon.png',
                        width: 35.0,
                        height: 35.0,
                      ),
                      Container(width: 10.0),
                      Text(
                        "찜 하기",
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 5.0),
                Container(
                  height: 40,
                  width: buttonWidth,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    border: Border.all(
                      color: Color(0xFFD9D9D9),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/simple_alert_gray.png',
                        width: 35.0,
                        height: 35.0,
                      ),
                      Container(width: 5.0),
                      Text(
                        "알림 받기",
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: Color(0xFFB5B5B5),
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 5.0),
                Container(
                  height: 40,
                  width: buttonWidth,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    border: Border.all(
                      color: Color(0xFFD9D9D9),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/simple_alert_gray.png',
                        width: 35.0,
                        height: 35.0,
                      ),
                      Container(width: 5.0),
                      Text(
                        "지난 밀집도",
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: Color(0xFFB5B5B5),
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    border: Border.all(
                      color: Color(0xFFD9D9D9),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Image.asset(
                    'assets/images/simple_alert_gray.png',
                    width: 35.0,
                    height: 35.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget infoBox() {
    return Container(
      height: 365.0,
      child: Column(
        children: <Widget>[
          parkMainInfoBox(),
          parkDetailInfoBox(),
        ],
      ),
    );
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
            desiredAccuracy: LocationAccuracy.high);
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
