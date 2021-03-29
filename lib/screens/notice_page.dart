import 'package:boombee/services/github_api/get_notices.dart';
import 'package:flutter/material.dart';

//공지사항 페이지

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<Notice> _notices;
  List<bool> _isSelected = [];
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    asyncMethods();
  }

  void asyncMethods() async {
    List<Notice> notices = await fetchNotices();
    for (int i = 0; i < notices.length; i++) {
      _isSelected.add(false);
    }

    if (mounted) {
      setState(() {
        _notices = notices;
        _isLoaded = true;
      });
    }
  }

  Widget notice(int index) {
    TextStyle titleTextStyle = TextStyle(
      fontSize: 18,
    );

    BoxDecoration titleDecoration = BoxDecoration(
      color: Colors.white,
      border: Border(
          bottom: BorderSide(
        width: 1.0,
        color: Color(0xFFD9D9D9),
      )),
    );

    TextStyle bodyTextStyle = TextStyle(
      fontSize: 15,
    );

    BoxDecoration bodyDecoration = BoxDecoration(
      color: Colors.black12,
      border: Border(
          bottom: BorderSide(
        width: 1.0,
        color: Color(0xFFE8E8E8),
      )),
    );

    EdgeInsetsGeometry _padding = EdgeInsets.all(20.0);

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isSelected[index] = !_isSelected[index];
            });
          },
          child: Container(
            height: 70,
            decoration: titleDecoration,
            padding: _padding,
            child: Row(
              children: [
                Expanded(
                  flex: 15,
                  child: Container(
                    child: Text(
                      _notices[index].title,
                      style: titleTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _isSelected[index]
                      ? Icon(Icons.keyboard_arrow_up)
                      : Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        ),
        _isSelected[index]
            ? Container(
                decoration: bodyDecoration,
                padding: _padding,
                alignment: Alignment.centerLeft,
                child: Text(
                  _notices[index].body,
                  style: bodyTextStyle,
                ),
              )
            : Container(),
      ],
    );
  }

  Widget body() {
    return Container(
        child: ListView.builder(
      padding: EdgeInsets.only(top: 0.0),
      itemCount: _notices.length,
      itemBuilder: (context, index) {
        return notice(index);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF5F5F5),
        child: Column(
          children: [
            AppBarTitle(),
            Expanded(
              child: _isLoaded
                  ? body()
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
      ),
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
            child: Center(
              child: Text('공지 사항',
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
