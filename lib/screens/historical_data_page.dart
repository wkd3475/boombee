import 'package:boombee/services/github_api/get_parks_info.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoricalDataPage extends StatefulWidget {
  final Park park;

  HistoricalDataPage({@required this.park});

  @override
  _HistoricalDataPageState createState() => _HistoricalDataPageState();
}

class _HistoricalDataPageState extends State<HistoricalDataPage> {
  Park _park;
  CalendarController _calendarController;

  double logTitleHeight = 40.0;
  double logDataHeight = 40.0;
  double logTitleFontSize = 17.0;
  double logTimeFontSize = 15.0;
  double logDataFontSize = 13.0;

  Widget appBarTitle() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      height: 105,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(0xFFFFFFFFF),
          border: Border(
              bottom: BorderSide(
            width: 1.5,
            color: Color(0xFFD9D9D9),
          ))),
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
              child: Text('지난 밀집도',
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
                  "assets/images/simple_alert.png",
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

  Widget calendarBox() {
    return Container(
      color: Color(0xCCFF9300),
      child: TableCalendar(
        onDaySelected:
            (DateTime dateTime, List<dynamic> event, List<dynamic> holiday) {},
        calendarController: _calendarController,
        headerStyle: HeaderStyle(
          headerMargin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          titleTextStyle: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          formatButtonVisible: false,
          leftChevronVisible: false,
          rightChevronVisible: false,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: TextStyle(
                color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
            weekdayStyle: TextStyle(
                color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold)),
        calendarStyle: CalendarStyle(
          todayStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          todayColor: null,
          selectedStyle:
              TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
          selectedColor: Color(0xFFFFc065),
          weekdayStyle:
              TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
          weekendStyle:
              TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
          outsideWeekendStyle:
              TextStyle(color: Color(0x77FFFFFF), fontWeight: FontWeight.bold),
          outsideStyle: TextStyle(
            color: Color(0x77FFFFFF),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget densityImage(double density) {
    double size = 120;

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

  Widget parkMainInfoBox() {
    double bigFontSize = 20.0;
    double smallFontSize = 13.0;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFFF),
        border: Border(
          bottom: BorderSide(
            width: 1.5,
            color: Color(0xFFD9D9D9),
          ),
          top: BorderSide(
            width: 1.5,
            color: Color(0xFFD9D9D9),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Container(
              margin: EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 3.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _park.name,
                      style: TextStyle(
                        fontSize: bigFontSize,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _park.location,
                      style: TextStyle(
                        fontSize: smallFontSize,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ),
                  Container(height: 10.0),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xCCFF9300),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 15.0,
                          ),
                          Container(
                              width: 120.0,
                              child: Text(
                                "인구 밀집도 : ${_park.getLatestDensity().toStringAsFixed(1)}%",
                                style: TextStyle(
                                  fontSize: smallFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFFFFF),
                                ),
                              )),
                          Container(
                            child: Text(
                              "사람 간 평균 거리 : ${_park.getLatestAverageDistance().toStringAsFixed(1)}m",
                              style: TextStyle(
                                fontSize: smallFontSize,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
                alignment: Alignment.centerLeft,
                child: densityImage(_park.getLatestDensity())),
          ),
        ],
      ),
    );
  }

  Widget logTitle() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: logTitleHeight,
            decoration: BoxDecoration(
              color: Color(0xCCFF9300),
              border: Border(
                right: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
                bottom: BorderSide(
                  color: Color(0xFFD9D9D9),
                  width: 1.0,
                ),
              ),
            ),
            child: Center(
              child: Text(
                "시각",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: logTitleFontSize,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: logTitleHeight,
            decoration: BoxDecoration(
              color: Color(0xCCFF9300),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFD9D9D9),
                  width: 1.0,
                ),
              ),
            ),
            child: Center(
              child: Text(
                "인구 밀집도",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: logTitleFontSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget logBox() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          padding: EdgeInsets.all(0.0),
          itemCount: 24,
          scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: logDataHeight,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        border: Border(
                          right: BorderSide(
                            color: Color(0xFFD9D9D9),
                            width: 1.0,
                          ),
                          bottom: BorderSide(
                            color: Color(0xFFD9D9D9),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "$index시",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: logTimeFontSize,
                            color: Color(0xFF707070),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: logDataHeight,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFD9D9D9),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "$index%",
                          style: TextStyle(
                            fontSize: logDataFontSize,
                            color: Color(0xFF707070),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
        ),
      ),
    );
  }

  Widget parkDetailInfoBox() {
    return Expanded(
      child: Column(
        children: [
          logTitle(),
          logBox(),
        ],
      ),
    );
  }

  Widget infoBox() {
    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            parkMainInfoBox(),
            parkDetailInfoBox(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _park = widget.park;
    _calendarController = CalendarController();
    asyncMethods();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void asyncMethods() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            appBarTitle(),
            calendarBox(),
            infoBox(),
          ],
        ),
      ),
    );
  }
}
