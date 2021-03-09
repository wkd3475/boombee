import 'package:boombee/services/github_api/get_parks_info.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final List<String> _parkList;
  final bool _isSearched;
  final Map<String, Park> _parkInfoMap;

  SearchPage(this._parkList, this._isSearched, this._parkInfoMap);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

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
    print(widget._parkList.length);
    print(widget._isSearched);
    if (widget._parkList.length == 0 && widget._isSearched) {
      return Container(
        color: Color(0xFFF5F5F5),
        child: Center(
          child: Text(
            "검색 결과가 없습니다.",
            style: TextStyle(
              fontSize: 18,
            ),
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
        itemCount: widget._parkList.length,
        itemBuilder: (context, index) {
          return parkCard(widget._parkInfoMap[widget._parkList[index]]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: parkListBox(),
    );
  }
}
