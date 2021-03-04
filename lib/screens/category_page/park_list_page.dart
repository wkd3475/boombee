import 'dart:async';

import 'package:boombee/globals.dart';
import 'package:boombee/services/github_api/get_parks_info.dart';
import 'package:boombee/services/github_api/search_by_gu_api.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ParkListPage extends StatefulWidget {
  final String guId;

  ParkListPage({@required this.guId});

  @override
  _ParkListPageState createState() => _ParkListPageState();
}

class _ParkListPageState extends State<ParkListPage> {
  List<String> _parkList;
  Map<String, Park> _parkInfoMap;
  Position _position;

  int _currentState = 0;
  String _guId;
  int _order = 0;
  bool _isLocationServiceEnabled = true;
  bool _isTimeLimited = false;

  void ordering() {
    if (!_isLocationServiceEnabled && _order == 0) {
      return;
    }

    if (_order == 0) {
      for (int i=0; i<_parkList.length; i++) {
        for (int j=i+1; j<_parkList.length; j++) {
          List p1 = _parkInfoMap[_parkList[i]].getLocation();
          List p2 = _parkInfoMap[_parkList[j]].getLocation();
          double d1 = Geolocator.distanceBetween(_position.latitude, _position.longitude, p1[0], p1[1]);
          double d2 = Geolocator.distanceBetween(_position.latitude, _position.longitude, p2[0], p2[1]);

          if (d1 > d2) {
            var temp = _parkList[i];
            _parkList[i] = _parkList[j];
            _parkList[j] = temp;
          }
        }
      }
    } else {
      for (int i=0; i<_parkList.length; i++) {
        for (int j=i+1; j<_parkList.length; j++) {
          double d1 = _parkInfoMap[_parkList[i]].getLatestDensity();
          double d2 = _parkInfoMap[_parkList[j]].getLatestDensity();

          if (d1 > d2) {
            var temp = _parkList[i];
            _parkList[i] = _parkList[j];
            _parkList[j] = temp;
          }
        }
      }
    }
  }

  Widget densityImage(double density) {
    double size = 90;

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

  Widget parkCard(parkId, park, location, density, averageLength) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/ParkInfoPage',
          arguments: parkId,
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 15.0),
        child: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 7,
                child: Container(
                  margin: EdgeInsets.all(23.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 3.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          park,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF707070),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF707070),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 120.0,
                            child: Text(
                              "밀집도 : ${density.toStringAsFixed(1)}%",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xCCFF9300),
                              ),
                            ),
                          ),
                          Text(
                            "평균거리 : ${averageLength.toStringAsFixed(1)}m",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xCCFF9300),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: densityImage(density),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget parkListBox() {
    if (_parkList.length == 0) {
      return Center(
        child: Text(
          "${guId2name[_guId]}에 위치한 공원이 없습니다.",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }

    if (_isTimeLimited && _order == 0) {
      return Center(
        child: Text(
          "위치 정보를 불러오지 못했습니다.",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }

    if (!_isLocationServiceEnabled && _order == 0) {
      return Center(
        child: Text(
          "GPS가 활성화되지 않았습니다.",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }

    return Container(
      color: Color(0xFFF5F5F5),
      padding: EdgeInsets.all(25.0),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 0.0),
        itemExtent: 140.0,
        itemCount: _parkList.length,
        itemBuilder: (context, index) {
          String name = _parkInfoMap[_parkList[index]].name;
          String location = _parkInfoMap[_parkList[index]].location;
          double density = _parkInfoMap[_parkList[index]].getLatestDensity();
          double averageDistance = _parkInfoMap[_parkList[index]].getLatestAverageDistance();
          return parkCard(_parkList[index], name, location, density, averageDistance);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _guId = widget.guId;
    asyncMethods();
  }

  void asyncMethods() async {
    _parkList = await fetchSearchByGu(widget.guId);
    _parkInfoMap = await fetchGetParksInfoMap();
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
    setState(() {
      _currentState = 1;
      if (_isTimeLimited)
        return;
      ordering();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          AppBarTitle(),
          Container(
            padding: EdgeInsets.only(left: 25, bottom: 5, right: 25),
            height: 80,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              border: Border(
                bottom: BorderSide(
                  width: 1.5,
                  color: Color(0xFFD9D9D9),
                ),
              ),
            ),
            child: Row(
              children: [
                Align(
                  child: Text(
                    '지역별 공원',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF707070),
                    ),
                  ),
                ),
                Spacer(),
                Align(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _order = 0;
                        if (_isTimeLimited)
                          return;
                        ordering();
                      });
                    },
                    child: Text('거리순',
                        style: TextStyle(
                            height: 3,
                            color: _order == 0
                                ? Color(0xFF707070)
                                : Color(0xFFB5B5B5))),
                  ),
                ),
                Container(
                  width: 15,
                ),
                Align(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _order = 1;
                        ordering();
                      });
                    },
                    child: Text('밀집도 낮은순',
                        style: TextStyle(
                            height: 3,
                            color: _order == 1
                                ? Color(0xFF707070)
                                : Color(0xFFB5B5B5))),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: _currentState == 0
            ? Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: CircularProgressIndicator(),
              ),
            )
            : parkListBox(),
          ),
        ],
      ),
    ));
  }
}

class AppBarTitle extends StatefulWidget {
  _AppBarTitleState createState() => _AppBarTitleState();
}

class _AppBarTitleState extends State<AppBarTitle> {
  @override
  Widget build(BuildContext context) {
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
              child: Text('공원 보기',
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
                  "assets/images/search_icon.png",
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
}
