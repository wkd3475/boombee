import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 400,
        ),
//        Container(
//          margin: EdgeInsets.all(30),
//          child: Column(
//            children: <Widget>[
//            ],
//          ),
//        ),
      ],
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
      padding: EdgeInsets.only(top: 15.0, left: 30.0, right: 10),
      height: 105,
      decoration: BoxDecoration(
        color: Color(0xFFFF9300),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 360,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Positioned(
                child: Container(
              margin: EdgeInsets.only(left: 25),
              child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '검색어를 입력하세요.',
                      hintStyle: TextStyle(
                          color: Color.fromARGB(255, 181, 181, 181)))),
            )),
            Positioned(
              right: 70,
              child: FlatButton(
                onPressed: null,
                child: Image.asset(
                  'assets/images/search_icon.png',
                  width: 35,
                  height: 35,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: FlatButton(
                onPressed: () {},
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
    );
  }
}
