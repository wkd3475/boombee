import 'package:boombee/services/github_api/get_parks_info.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map<String, Park> _parkInfoMap;
  List<String> _searchParkList = [];
  bool _isSearched = false;
  bool _isFetched = false;
  TextEditingController _textController = TextEditingController();

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
                    Expanded(
                      flex: 7,
                      child: _isFetched
                          ? Container(
                              padding: EdgeInsets.only(left: 25),
                              child: TextFormField(
                                controller: _textController,
                                onFieldSubmitted: _handleSubmitted,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '검색어를 입력하세요.',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 181, 181, 181),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.only(left: 25.0),
                              child: Text(
                                "검색어를 입력하세요.",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFB5B5B5),
                                ),
                              ),
                            ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          currentFocus.unfocus();
                          searchByString(_textController.text);
                        },
                        child: Image.asset(
                          'assets/images/search_icon.png',
                          width: 35,
                          height: 35,
                        ),
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
                  Navigator.pop(context);
                },
                child: Image.asset(
                  "assets/images/left_arrow.png",
                  width: 45,
                  height: 45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                          Expanded(
                            flex: 2,
                            child: Text(
                              "밀집도 : ${park.getLatestDensity().toStringAsFixed(1)}%",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xCCFF9300),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "사람 간 평균 거리 : ${park.getLatestAverageDistance().toStringAsFixed(1)}m",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xCCFF9300),
                              ),
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
                child: Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: densityImage(park.getLatestDensity()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget parkListBox() {
    if (!_isSearched) {
      return Expanded(
        child: Container(
          color: Color(0xFFF5F5F5),
        ),
      );
    }
    print(_searchParkList.length);
    print(_isSearched);
    if (_searchParkList.length == 0 && _isSearched) {
      return Expanded(
        child: Container(
          color: Color(0xFFF5F5F5),
          child: Center(
            child: Text(
              "검색 결과가 없습니다.",
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
        color: Color(0xFFF5F5F5),
        padding: EdgeInsets.all(25.0),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 0.0),
          itemCount: _searchParkList.length,
          itemBuilder: (context, index) {
            return parkCard(_parkInfoMap[_searchParkList[index]]);
          },
        ),
      ),
    );
  }

  void searchByString(String text) {
    if (text == "" && text == " ") {
      setState(() {
        _searchParkList = [];
        _isSearched = true;
      });
      return;
    }
    List<String> result = [];
    Map<String, String> words = {};

    _parkInfoMap.forEach((k, v) {
      words[v.name] = k;
      words[v.location] = k;
    });

    words.forEach((k, v) {
      if (k.contains(text)) {
        result.add(v);
      }
    });

    setState(() {
      _searchParkList = result.toSet().toList();
      _isSearched = true;
    });
  }

  void _handleSubmitted(String text) {
    searchByString(_textController.text);
  }

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
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            appBarTitle(),
            parkListBox(),
          ],
        ),
      ),
    );
  }
}
