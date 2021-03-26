import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:boombee/services/github_api/get_parks_info.dart';
import 'package:geolocator/geolocator.dart';

class SurroundingMapPage extends StatefulWidget {
  @override
  _SurroundingMapPageState createState() => _SurroundingMapPageState();
}

class _SurroundingMapPageState extends State<SurroundingMapPage> {
  Position _position;
  Map<String, Park> _parkInfoMap;
  Completer<GoogleMapController> _controller = Completer();

  int _currentState = 0;
  bool _isLocationServiceEnabled = true;
  bool _isTimeLimited = true;

  Widget appBarTitle() {
    return Container(
      padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10),
      height: 105,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/SearchPage',
            arguments: _parkInfoMap,
          );
        },
        child: Container(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xCCFF9300),
                      child: Image.asset(
                        "assets/images/left_arrow.png",
                        width: 30,
                        height: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          "검색어를 입력하세요.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFFB5B5B5),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Image.asset(
                          'assets/images/search_icon.png',
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/AlertPage',
                    );
                  },
                  child: Image.asset(
                    "assets/images/alert_icon.png",
                    width: 45,
                    height: 45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    if (!_isLocationServiceEnabled) {
      return Center(
        child: Text("GPU가 활성화되지 않았습니다."),
      );
    }

    if (_currentState == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_isTimeLimited) {
      return Center(
        child: Text("현재 위치 정보를 불러올 수 없습니다."),
      );
    }

    List<Circle> circleList = [];

    _parkInfoMap.forEach((key, value) {
      if (value.hasData()) {
        double densityToOpacity = 0x255 * value.getLatestDensity() / 100;

        circleList.add(Circle(
          circleId: CircleId(value.id),
          center: LatLng(value.latitude, value.longitude),
          radius: value.radius.toDouble(),
          fillColor: Color.fromRGBO(0xFF,0x93,0x0,densityToOpacity),
          strokeWidth: 0,
        ));
      }
    });

    Set<Circle> circles = Set.from(circleList);

    CameraPosition _currentPosition = CameraPosition(
      target: LatLng(_position.latitude, _position.longitude),
      zoom: 14.4746,
    );

    List<Marker> markerList = [];
    markerList.add(Marker(markerId: MarkerId("0"), position: LatLng(_position.latitude, _position.longitude)));

    Set<Marker> markers = Set.from(markerList);

    return Container(
      child: GoogleMap(
        mapType: MapType.normal,
        circles: circles,
        initialCameraPosition: _currentPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    asyncMethods();
  }

  void asyncMethods() async {
    _parkInfoMap = await fetchGetParksInfoMap();
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
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Container(
        height: maxHeight,
        width: maxWidth,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                height: maxHeight,
                width: maxWidth,
              ),
            ),
            Positioned(
              child: body(),
            ),
            Positioned(child: appBarTitle()),
          ],
        ),
      ),
    );
  }
}
