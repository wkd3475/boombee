import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  Widget item(text) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Color(0xFFD9D9D9),
            ),
          ),
        ),
        height: 90,
        child: Row(
          children: <Widget>[
            Container(width: 25),
            Image.asset(
              "assets/images/right-bracket.png",
              width: 35,
              height: 35,
            ),
            Container(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF707070),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBarTitle(),
        Container(
          padding: EdgeInsets.only(left: 25, bottom: 5),
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
        ),
        Container(
            color: Color(0xFFF5F5F5),
            child: Container(
              child: Column(
                children: <Widget>[
                  item("공지 사항"),
                  item("데이터 처리 과정"),
                ],
              ),
            )),
      ],
    );
  }
}

class AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40.0),
      height: 120,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFFF),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('마이 페이지',
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