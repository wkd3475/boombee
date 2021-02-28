import 'package:flutter/material.dart';

class ParkListPage extends StatefulWidget {
  final List<String> parks;
  ParkListPage({@required this.parks});

  @override
  _ParkListPageState createState() => _ParkListPageState(parks:parks);
}

class _ParkListPageState extends State<ParkListPage> {
  final List<String> parks;
  _ParkListPageState({this.parks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          Text("$parks"),
        ],
      )
    );
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