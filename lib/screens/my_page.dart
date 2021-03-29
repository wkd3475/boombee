import 'package:flutter/material.dart';

//공지사항과 데이터 처리 과정로 전환 가능한 페이지

class MyPage extends StatelessWidget {
  Widget item(text, context) {
    return GestureDetector(
      onTap: () {
        if (text=="공지 사항") {
          Navigator.pushNamed(
            context,
            '/NoticePage',
          );
        }
        if (text=="데이터 처리 과정") {
          Navigator.pushNamed(
            context,
            '/DataProcessingPage',
          );
        }
      },
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
            color: Color(0xFFF5F5F5),
            child: Container(
              child: Column(
                children: <Widget>[
                  item("공지 사항", context),
                  item("데이터 처리 과정", context),
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
        color: Color(0xFFFFFFFF),
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Color(0xFFD9D9D9),
          ),
        ),
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