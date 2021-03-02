import 'package:boombee/globals.dart';
import 'package:boombee/services/corona_api/git_server_api.dart';
import 'package:boombee/services/corona_api/search_by_gu_api.dart';
import 'package:flutter/material.dart';

class ParkListPage extends StatefulWidget {
  final String guId;

  ParkListPage({@required this.guId});

  @override
  _ParkListPageState createState() => _ParkListPageState();
}

class _ParkListPageState extends State<ParkListPage> {
  Future<Map<String, dynamic>> _parks;
  String guId;
  int order = 0;

  List<dynamic> ordering(parks) {
    if (order == 0) {
      return parks;
    } else {
      return parks;
    }
  }

  Widget densityImage(density) {
    var d = int.parse(density);
    double size = 90;

    if (d >= 0 && d < 30) {
      return Image.asset(
        'assets/images/density_level_1.png',
        width: size,
        height: size,
      );
    } else if (d >= 30 && d < 60) {
      return Image.asset(
        'assets/images/density_level_2.png',
        width: size,
        height: size,
      );
    } else if (d >= 60 && d < 80) {
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

  Widget parkCard(park, location, density, averageLength) {
    return Card(
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
                          fontSize: 20,
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
                          width: 100.0,
                          child: Text(
                            "밀집도 : $density%",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xCCFF9300),
                            ),
                          ),
                        ),
                        Text(
                          "평균거리 : ${averageLength}m",
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
    );
  }

  @override
  void initState() {
    super.initState();
    guId = widget.guId;
    _parks = fetchSearchByGu(widget.guId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          AppBarTitle(),
          Container(
            padding: EdgeInsets.only(left: 25, bottom: 5),
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
            child: Text(
              '지역별 공원',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF707070),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(25.0),
              child: FutureBuilder(
                future: _parks,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> parks = ordering(snapshot.data[guId]);
                    if (parks.length == 0) {
                      return Center(
                        child: Text(
                          "${guId2name[guId]}에 위치한 공원이 없습니다.",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 0.0),
                      itemExtent: 140.0,
                      itemCount: parks.length,
                      itemBuilder: (context, index) {
                        return parkCard("$index공원", "성북구 안암동", "30", "100");
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
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
