import 'package:boombee/utils/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../globals.dart' as globals;

class AlertPage extends StatefulWidget {
  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  int _selectedIndex = 0;
  bool _isSwitchOn = true;
  List<String> period = [
    "30분 마다",
    "1시간 마다",
    "1시간 30분 마다",
    "2시간 마다",
    "2시간 30분 마다",
    "3시간 마다"
  ];

  Widget appBarTitle(double maxWidth, double maxHeight) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      height: maxHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Color(0xFFFFFFFFF)),
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
              child: Text('알림 설정',
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

  Widget alertSwitchOnButton(double maxWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSwitchOn = false;
        });
      },
      child: Container(
        height: 70,
        width: maxWidth,
        decoration: BoxDecoration(
          color: Color(0xCCFF9300),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            "ON",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget alertSwitchOffButton(double maxWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSwitchOn = true;
        });
      },
      child: Container(
        height: 70,
        width: maxWidth,
        decoration: BoxDecoration(
          color: Color(0xFFE8E8E8),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            "OFF",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget parkCard(Alert alert, int index) {
    return Slidable(
      key: Key(alert.parkId),
      actionPane: SlidableDrawerActionPane(),
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          setState(() {
            globals.alertManager.remove(alert.parkId);
          });
        },
      ),
      actionExtentRatio: 0.15,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: _selectedIndex == index ? Colors.black12 : Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 3.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        globals.parkId2name[alert.parkId],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF707070),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      period[alert.periodType],
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      secondaryActions: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              globals.alertManager.remove(alert.parkId);
            });
          },
          child: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xCCFF9300),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              height: 130,
              child: Center(
                child: Image.asset(
                  'assets/images/delete.png',
                  color: Colors.white,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget parkListBox() {
    if (globals.alertManager.alertList.length == 0) {
      return Center(
        child: Text(
          "알림 설정한 공원이 없습니다.",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFB5B5B5),
          ),
        ),
      );
    }

    return Container(
      color: Color(0xFFF5F5F5),
      padding: EdgeInsets.all(10.0),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 0.0),
        itemExtent: 80.0,
        itemCount: globals.alertManager.alertList.length,
        itemBuilder: (context, index) {
          return parkCard(globals.alertManager.alertList[index], index);
        },
      ),
    );
  }

  Widget periodButton(int index) {
    int periodType = globals.alertManager.alertList[_selectedIndex].periodType;
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          setState(() {
            globals.alertManager.update(globals.alertManager.alertList[_selectedIndex], index);
          });
        },
        child: Container(
          height: 35,
          decoration: periodType == index
              ? BoxDecoration(
                  color: Color(0xCCFF9300),
                  border: Border.all(
                    color: Color(0xFFFF9300),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                )
              : BoxDecoration(
                  color: Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  border: Border.all(
                    color: Color(0xFFD9D9D9),
                    width: 1.0,
                  ),
                ),
          child: Center(
            child: Text(
              period[index],
              style: TextStyle(
                color: periodType == index ? Colors.white : Color(0xFFB5B5B5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget periodBox() {
    return Column(
      children: [
        Container(height: 30.0),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "알림 받을 시간 설정",
            style: TextStyle(
              color: Color(0xFF707070),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        Container(height: 10.0),
        Row(
          children: [
            periodButton(0),
            Container(width: 5.0),
            periodButton(1),
            Container(width: 5.0),
            periodButton(2)
          ],
        ),
        Container(height: 5.0),
        Row(
          children: [
            periodButton(3),
            Container(width: 5.0),
            periodButton(4),
            Container(width: 5.0),
            periodButton(5)
          ],
        ),
        Container(height: 20.0),
      ],
    );
  }

  Widget body(double maxWidth, double maxHeight) {
    return Container(
      color: Colors.white,
      height: maxHeight,
      padding: EdgeInsets.all(30.0),
      child: _isSwitchOn
          ? Column(
              children: [
                alertSwitchOnButton(maxWidth),
                Container(height: 40.0),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "알림 설정한 공원 목록",
                    style: TextStyle(
                      color: Color(0xFF707070),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(height: 20),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFE8E8E8),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: parkListBox(),
                  ),
                ),
                periodBox(),
              ],
            )
          : Column(
              children: [
                alertSwitchOffButton(maxWidth),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "알림을 키면 알림 설정한 공원 목록과 알림 시간을 설정할 수 있습니다.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF707070),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          appBarTitle(maxWidth, 105),
          body(maxWidth, maxHeight - 105),
        ],
      ),
    );
  }
}
