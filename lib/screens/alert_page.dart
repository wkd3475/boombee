import 'package:boombee/utils/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../globals.dart' as globals;

//알림 설정 관련 페이지

class AlertPage extends StatefulWidget {
  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
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

  //스위치 온 상태의 버튼을 출력
  Widget alertSwitchOnButton(double maxWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          globals.alertManager.switchOff();
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

  //스위치 오프 상태의 버튼을 출력
  Widget alertSwitchOffButton(double maxWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          globals.alertManager.switchOn();
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

  //추가된 공원에 대한 카드를 출력
  Widget parkCard(String parkId, int index) {
    return Slidable(
      key: Key(parkId),
      actionPane: SlidableDrawerActionPane(),
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          setState(() {
            globals.alertManager.remove(parkId);
          });
        },
      ),
      actionExtentRatio: 0.15,
      child: Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
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
                      globals.parkId2name[parkId],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      secondaryActions: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              globals.alertManager.remove(parkId);
            });
          },
          child: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xCCFF9300),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              height: 70,
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

  //알림 추가된 공원 리스트를 보여주기 위한 용도로 사용됨
  Widget parkListBox() {
    if (globals.alertManager.alert.parks.length == 0) {
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
        itemCount: globals.alertManager.alert.parks.length,
        itemBuilder: (context, index) {
          return parkCard(globals.alertManager.alert.parks[index], index);
        },
      ),
    );
  }

  //하나의 주기에 대한 버튼을 출력할 때 사용됨, index는 버튼의 번호를 의미하며, 이를 바탕으로 어떤 문구가 출력되고 어떤 기능을 수행할지 결정됨.
  Widget periodButton(int index) {
    int periodType = globals.alertManager.alert.periodType;
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          setState(() {
            globals.alertManager.updatePeriod(index);
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
              Alert.periodTypeToString[index],
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

  //주기 버튼 6개가 포함되는 하나의 표라고 생각하면 됨.
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

  //타이틀을 제외한 나머지 부분에 해당됨.
  Widget body(double maxWidth, double maxHeight) {
    return Container(
      color: Colors.white,
      height: maxHeight,
      padding: EdgeInsets.all(30.0),
      child: globals.alertManager.isSwitchOn()
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
