import 'dart:async';

import 'package:boombee/services/github_api/get_parks_info.dart';
import 'package:boombee/utils/toast.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';


import '../globals.dart' as globals;

class ParkInfoPage extends StatefulWidget {
  final Park park;

  ParkInfoPage({@required this.park});

  @override
  _ParkInfoPageState createState() => _ParkInfoPageState();
}

class _ParkInfoPageState extends State<ParkInfoPage> {
  Position _position;
  bool _isLocationServiceEnabled = true;
  bool _isTimeLimited = true;
  int _currentState = 0;

  Park _park;

  File _imageFile;

  ScreenshotController screenshotController = ScreenshotController();
  Completer<GoogleMapController> _controller = Completer();

  _takeScreenshotandShare() async {
    _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((File image) async {
      setState(() {
        _imageFile = image;
      });
      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile.readAsBytesSync();
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Saved to Gallery");
      await Share.file('Boombee', 'screenshot.png', pngBytes, 'image/png');
    }).catchError((onError) {
      print(onError);
    });
  }

  FutureOr<dynamic> onGoBack(dynamic) {
    setState(() {});
  }

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
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/AlertPage',
                  ).then(onGoBack);
                },
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
    double densityToOpacity = 0x255 * _park.getLatestDensity() / 100;

    Set<Circle> circles = Set.from([
      Circle(
        circleId: CircleId(_park.id),
        center: LatLng(_park.latitude, _park.longitude),
        radius: _park.radius.toDouble(),
        fillColor: Color.fromRGBO(0xFF, 0x93, 0x0, densityToOpacity),
        strokeWidth: 0,
      )
    ]);

    CameraPosition _currentPosition = CameraPosition(
      target: LatLng(_park.latitude, _park.longitude),
      zoom: 14.4746,
    );

    List<Marker> markerList = [];

    if (_currentState == 1) {
      markerList.add(Marker(markerId: MarkerId("0"), position: LatLng(_position.latitude, _position.longitude)));
    }

    Set<Marker> markers = Set.from(markerList);

    return Expanded(
      child: Container(
        width: widthSize,
        child: GoogleMap(
          mapType: MapType.normal,
          circles: circles,
          initialCameraPosition: _currentPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: markers,
        ),
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
    double bigFontSize = 17.0;
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
            flex: 3,
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
                  Container(height: 5.0),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 400,
                            child: Text(
                              "인구 밀집도 : ${_park.getLatestDensity().toStringAsFixed(1)}%",
                              style: TextStyle(
                                fontSize: smallFontSize,
                                fontWeight: FontWeight.bold,
                                color: Color(0xCCFF9300),
                              ),
                            ),
                          ),
                          Container(height: 5.0),
                          Container(
                            width: 400,
                            child: Text(
                              "사람 간 평균 거리 : ${_park.getLatestAverageDistance().toStringAsFixed(1)}m",
                              style: TextStyle(
                                fontSize: smallFontSize,
                                fontWeight: FontWeight.bold,
                                color: Color(0xCCFF9300),
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
            flex: 1,
            child: Container(
                padding: EdgeInsets.only(right: 20.0),
                alignment: Alignment.centerLeft,
                child: densityImage(_park.getLatestDensity())),
          ),
        ],
      ),
    );
  }

  Widget parkDetailInfoBox() {
    double bigFontSize = 20.0;
    double smallFontSize = 13.0;
    double buttonWidth = 120;
    double iconSize = 20.0;

    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(30.0),
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
              Expanded(
                flex: 5,
                child: GestureDetector(
                  onTap: () {
                    if (globals.subscribe.isSubscribed(_park.id)) {
                      globals.subscribe.remove(_park.id);
                      flutterToast("찜한 목록에서 삭제되었습니다.", context);
                    } else {
                      globals.subscribe.add(_park.id);
                      flutterToast("찜한 목록에 추가되었습니다.", context);
                    }
                    setState(() {});
                  },
                  child: globals.subscribe.isSubscribed(_park.id) ? Container(
                    height: 40,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      color: Color(0xCCFF9300),
                      border: Border.all(
                        color: Color(0xFFFF9300),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/heart_white_icon.png',
                          width: iconSize,
                          height: iconSize,
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
                  ) : Container(
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
                          'assets/images/heart_icon.png',
                          width: iconSize,
                          height: iconSize,
                        ),
                        Container(width: 10.0),
                        Text(
                          "찜 하기",
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
                ),
              ),
              Container(width: 5.0),
              Expanded(
                flex: 5,
                child: GestureDetector(
                  onTap: () {
                    if (globals.alertManager.isInAlertList(_park.id)) {
                      globals.alertManager.remove(_park.id);
                      flutterToast("알림 목록에서 삭제되었습니다.", context);
                    } else {
                      globals.alertManager.add(_park.id);
                      flutterToast("알림 목록에 추가되었습니다.", context);
                    }
                    setState(() {});
                  },
                  child: globals.alertManager.isInAlertList(_park.id) ? Container(
                    height: 40,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      color: Color(0xCCFF9300),
                      border: Border.all(
                        color: Color(0xFFFF9300),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/simple_alert_gray.png',
                          width: iconSize,
                          height: iconSize,
                          color: Colors.white,
                        ),
                        Container(width: 5.0),
                        Text(
                          "알림 받기",
                          style: TextStyle(
                            fontSize: smallFontSize,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ) : Container(
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
                          width: iconSize,
                          height: iconSize,
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
                ),
              ),
              Container(width: 5.0),
              Expanded(
                flex: 5,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/HistoricalDataPage',
                      arguments: _park,
                    );
                  },
                  child: Container(
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
                          'assets/images/calendar_icon.png',
                          width: iconSize,
                          height: iconSize,
                        ),
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
                ),
              ),
              Spacer(),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    _takeScreenshotandShare();
                  },
                  child: Container(
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
                      'assets/images/share_icon.png',
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoBox() {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        child: Column(
          children: <Widget>[
            parkMainInfoBox(),
            parkDetailInfoBox(),
          ],
        ),
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
      } catch (e) {
        _isTimeLimited = true;
        return;
      }
    } else {
      _isLocationServiceEnabled = false;
      return;
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
