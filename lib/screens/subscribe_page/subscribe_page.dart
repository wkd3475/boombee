import 'package:boombee/services/github_api/get_parks_info.dart';
import 'package:flutter/material.dart';
import '../../globals.dart' as globals;


class SubscribePage extends StatefulWidget {
  @override
  _SubscribePageState createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  bool isFetched = false;
  Map<String, Park> _parkInfoMap;

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

  Widget parkCard(Park park) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/ParkInfoPage',
          arguments: park,
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
                          park.name,
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
                          park.location,
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
                              "밀집도 : ${park.getLatestDensity().toStringAsFixed(1)}%",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xCCFF9300),
                              ),
                            ),
                          ),
                          Text(
                            "사람 간 평균 거리 : ${park.getLatestAverageDistance().toStringAsFixed(1)}m",
                            style: TextStyle(
                              fontSize: 13,
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
                child: densityImage(park.getLatestDensity()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget parkListBox() {
    if (globals.subscribe.subscribeList.length == 0) {
      return Center(
        child: Text(
          "찜한 공원이 없습니다.",
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
        itemCount: globals.subscribe.subscribeList.length,
        itemBuilder: (context, index) {
          return parkCard(_parkInfoMap[globals.subscribe.subscribeList[index]]);
        },
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
    setState(() {
      isFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
            children: [
              SubscribePageTitle(),
              Expanded(
                child: isFetched
                  ? parkListBox()
                  : Center(
                  child: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ),);
  }
}

class SubscribePageTitle extends StatefulWidget {
  _SubscribePageTitleState createState() => _SubscribePageTitleState();
}

class _SubscribePageTitleState extends State<SubscribePageTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      height: 105,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFFF),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              child: Text('찜한 목록',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF707070))),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }
}