import 'package:boombee/services/corona_api/corona_api.dart';
import 'package:boombee/services/github_api/get_parks_info.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFetched = false;

  Map<String, Park> _parkInfoMap;

  @override
  void initState() {
    super.initState();
    asyncMethods();
  }

  void asyncMethods() async {
    _parkInfoMap = await fetchGetParksInfoMap();
    setState(() {
      _isFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        appBarTitle(),
        MainInfoPage(),
      ],
    );
  }

  Widget appBarTitle() {
    return Container(
      padding: EdgeInsets.only(top: 15.0, left: 30.0, right: 10),
      height: 105,
      decoration: BoxDecoration(
        color: Color(0xCCFF9300),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
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
                flex: 5,
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
                        child: Text("검색어를 입력하세요.",
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
                flex: 1,
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
}

class MainInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10,),
      child: Column(
        children: <Widget>[
          CurrentStatusCard(),
          Container(height: 20.0),
          UnpopularParkTitle(),
          UnpopularPark(),
        ],
      ),
    );
  }
}

class CurrentStatusCard extends StatefulWidget {
  _CurrentStatusCard createState() => _CurrentStatusCard();
}

class _CurrentStatusCard extends State<CurrentStatusCard> {
  Future<Corona> _coronaInfo;
  DateTime now = new DateTime.now();
  double h = 25.0;

  Widget box1(text) {
    return Container(
      height: h,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
      ),
      color: Color(0xCCFF9300),
    );
  }

  Widget box2(text) {
    return Container(
      height: h,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
      ),
      color: Color(0x88FF9300),
    );
  }

  Widget box3(text) {
    return Container(
      height: h,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE8E8E8),
            width: 1.0,
          ),
        ),
      ),
    );
  }

  Widget box4(text) {
    return Container(
      height: h,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE8E8E8),
            width: 1.0,
          ),
        ),
      ),
    );
  }

  Widget infoRow(text1, value1, text2, value2, text3, value3) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: box3(text1),
        ),
        Expanded(
          flex: 1,
          child: box4(value1),
        ),
        Expanded(
          flex: 1,
          child: box3(text2),
        ),
        Expanded(
          flex: 1,
          child: box4(value2),
        ),
        Expanded(
          flex: 1,
          child: box3(text3),
        ),
        Expanded(
          flex: 1,
          child: box4(value3),
        ),
      ],
    );
  }

  Widget currentStatusCard(json) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "코로나 확진 현황",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF707070),
                  ),
                ),
                Text(
                  " (국내 해외 총합)",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF707070),
                  ),
                ),
                Spacer(),
                Text(
                  "${now.year}. ${now.month}. ${now.day}",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB5B5B5),
                  ),
                )
              ],
            ),
            Container(height: 8.0),
            Row(
              children: <Widget>[
                Text(
                  "일별 신규 확진자 수 : ${json.data.korea.newCase}명      ",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF9300),
                  ),
                ),
                Text(
                  "누적 확진자 수 : ${json.data.korea.totalCase}명",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF9300),
                  ),
                ),
              ],
            ),
            Container(height: 10.0),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: box1("지역"),
                ),
                Expanded(
                  flex: 1,
                  child: box2("신규"),
                ),
                Expanded(
                  flex: 1,
                  child: box1("지역"),
                ),
                Expanded(
                  flex: 1,
                  child: box2("신규"),
                ),
                Expanded(
                  flex: 1,
                  child: box1("지역"),
                ),
                Expanded(
                  flex: 1,
                  child: box2("신규"),
                ),
              ],
            ),
            infoRow("서울", json.data.seoul.newCase, "부산",
                json.data.busan.newCase, "대구", json.data.daegu.newCase),
            infoRow("인천", json.data.incheon.newCase, "광주",
                json.data.gwangju.newCase, "대전", json.data.daejeon.newCase),
            infoRow("울산", json.data.ulsan.newCase, "세종",
                json.data.sejong.newCase, "경기", json.data.gyeonggi.newCase),
            infoRow("강원", json.data.gangwon.newCase, "충북",
                json.data.chungbuk.newCase, "충남", json.data.chungnam.newCase),
            infoRow("전북", json.data.jeonbuk.newCase, "전남",
                json.data.jeonnam.newCase, "경북", json.data.gyeongbuk.newCase),
            infoRow("경남", json.data.gyeongnam.newCase, "제주",
                json.data.jeju.newCase, "-", "-"),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _coronaInfo = fetchCorona();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _coronaInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return currentStatusCard(snapshot);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class UnpopularParkTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            child: Container(
              alignment: Alignment.centerLeft,
              width: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(17.5)),
              ),
              child: Text(
                '지금 \'붐비\'지 않는 공원',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF707070),
                ),
              ),
            ),
          ),
          Align(
            child: Container(
              width: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xCCFF9300),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Text('내 주변',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class UnpopularPark extends StatefulWidget {
  @override
  _UnpopularParkState createState() => _UnpopularParkState();
}

class _UnpopularParkState extends State<UnpopularPark> {
  Future<List> _parksInfo;

  Widget densityImage(double density) {
    double size = 47;

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

  Widget infoRow(rank, Park park) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/ParkInfoPage',
          arguments: park,
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 3.0, bottom: 3.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  height: 47.0,
                  width: 47.0,
                  decoration: BoxDecoration(
                    color: Color(0x77FF9300),
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1.0,
                      color: Color(0xFFFF9300),
                    ),
                  ),
                  child: Text(
                    rank,
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
            Container(width: 30.0),
            Expanded(
              flex: 7,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 3.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      park.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 80.0,
                        child: Text(
                          "밀집도 : ${park.getLatestDensity().toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9300),
                          ),
                        ),
                      ),
                      Text(
                        "사람 간 평균 거리 : ${park.getLatestAverageDistance().toStringAsFixed(1)}m",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9300),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            densityImage(park.getLatestDensity()),
          ],
        ),
      ),
    );
  }

  Widget rankList(List<Park> parkInfoList) {
    for (int i = 0; i < parkInfoList.length; i++) {
      for (int j = i + 1; j < parkInfoList.length; j++) {
        if (parkInfoList[i].getLatestDensity() >
            parkInfoList[j].getLatestDensity()) {
          var temp = parkInfoList[i];
          parkInfoList[i] = parkInfoList[j];
          parkInfoList[j] = temp;
        }
      }
    }

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          infoRow("1", parkInfoList[0]),
          Divider(),
          infoRow("2", parkInfoList[1]),
          Divider(),
          infoRow("3", parkInfoList[2]),
          Divider(),
          infoRow("4", parkInfoList[3]),
          Divider(),
          infoRow("5", parkInfoList[4]),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _parksInfo = fetchGetParksInfoList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: FutureBuilder(
        future: _parksInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return rankList(snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
