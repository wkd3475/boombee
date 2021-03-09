import 'package:boombee/screens/park_list_page.dart';
import 'package:flutter/material.dart';

import '../globals.dart' as globals;

class CategoryPage extends StatefulWidget {
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CategoryPageTitle(),
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
        CategoryBox(),
      ],
    );
  }
}

class CategoryPageTitle extends StatefulWidget {
  _CategoryPageTitleState createState() => _CategoryPageTitleState();
}

class _CategoryPageTitleState extends State<CategoryPageTitle> {
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
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/SearchPage',
                  );
                },
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

class CategoryBox extends StatefulWidget {
  _CategoryBoxState createState() => _CategoryBoxState();
}

class _CategoryBoxState extends State<CategoryBox> {
  int _indexCity = 0;
  int _cityLength = 0;
  int _guLength = 0;

  @override
  Widget build(BuildContext context) {
    _cityLength = globals.cityIdList.length;
    _guLength = globals.cityId2guIdList[globals.cityIdList[_indexCity]].length;
    return Expanded(
      child: Container(
        color: Color(0xFFF5F5F5),
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
//                color: Color(0xFFF5F5F5),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 0.0),
                itemExtent: 60,
                itemCount: _cityLength,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var cityId = globals.cityIdList[index];
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _indexCity != index
                          ? Color(0xFFF5F5F5)
                          : Color(0xFFFFFFFF),
                      border: Border(
                        bottom: BorderSide(
                          width: 1.5,
                          color: Color(0xFFD9D9D9),
                        ),
                      ),
                    ),
                    child: ListTile(
                      title: FlatButton(
                        height: 20,
                        child: Text(
                          globals.cityId2name[cityId],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF707070),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _indexCity = index;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    border: Border(
                      left: BorderSide(
                        width: 1.5,
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                  ),
                )),
            Expanded(
              flex: 7,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 0.0),
                  itemExtent: 60.0,
                  itemCount: _guLength,
                  itemBuilder: (context, index) {
                    String guId = globals
                        .cityId2guIdList[globals.cityIdList[_indexCity]]
                    [index];
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.5,
                            color: Color(0xFFD9D9D9),
                          ),
                        ),
                      ),
                      child: ListTile(
                        tileColor: Color(0xFFFFFFFF),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                globals.guId2name[guId],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF707070),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/ParkListPage',
                                  arguments: guId,
                                );
                                // Navigator.of(context).pushNamed("/ParkListPage", arguments: guId);
                              },
                              child: Image.asset(
                                "assets/images/right-bracket.png",
                                width: 35,
                                height: 35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
