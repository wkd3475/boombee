import '../globals.dart' as globals;
import 'dart:convert';

// 알림 관련된 기능을 총괄함
class AlertManager {
  String keyAlert = "alert";
  Alert alert;

  Future<String> getAlert() async {
    return globals.prefs.getString(keyAlert);
  }

  void init() async {
    String data = await getAlert();

    if (data != null) {
      alert = Alert.fromJson(json.decode(data));
    } else { //default case
      List<String> alertList = [];
      alert = Alert(1, "null", false, alertList);
    }
    print("init alert : "+alert.toString());
  }

  void add(String parkId) {
    List<String> content = alert.parks;
    bool hasParkId = false;

    for (var i = 0; i < content.length; i++) {
      if (content[i] == parkId) {
        hasParkId = true;
      }
    }

    if (!hasParkId) {
      content.add(parkId);
    }

    Alert newAlert = Alert(alert.periodType, alert.startTime, alert.switchState, content);

    globals.prefs.setString(keyAlert, json.encode(Alert.toMap(newAlert)));
    alert = newAlert;
    print("add alert : "+alert.toString());
  }

  void remove(String parkId) {
    List<String> content = alert.parks;
    bool hasParkId = false;

    for (var i = 0; i < content.length; i++) {
      if (content[i] == parkId) {
        content.removeAt(i);
        hasParkId = true;
      }
    }

    if (!hasParkId) return;

    Alert newAlert = Alert(alert.periodType, alert.startTime, alert.switchState, content);

    globals.prefs.setString(keyAlert, json.encode(Alert.toMap(newAlert)));
    alert = newAlert;
    print("remove alert : "+alert.toString());
  }

  void updatePeriod(int periodType) {
    Alert newAlert = Alert(periodType, alert.startTime, alert.switchState, alert.parks);

    globals.prefs.setString(keyAlert, json.encode(Alert.toMap(newAlert)));
    alert = newAlert;
    print("update alert period : $alert");
  }

  void switchOn() {
    DateTime now = DateTime.now();
    DateTime _startTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    Alert newAlert = Alert(alert.periodType, _startTime.toString(), true, alert.parks);
    globals.prefs.setString(keyAlert, json.encode(Alert.toMap(newAlert)));
    alert = newAlert;
    print("alert switch on : $alert");
  }

  void switchOff() {
    Alert newAlert = Alert(alert.periodType, alert.startTime, false, alert.parks);
    globals.prefs.setString(keyAlert, json.encode(Alert.toMap(newAlert)));
    alert = newAlert;
    print("alert switch off : $alert");
  }

  bool isSwitchOn() {
    return alert.switchState;
  }

  bool isTimeToAlert() {
    int _period = Alert.periodTypeToMinutes[globals.alertManager.alert.periodType];
    DateTime now = DateTime.now();
    DateTime _now = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    DateTime _startTime = DateTime.parse(globals.alertManager.alert.startTime);
    int diff =_now.difference(_startTime).inMinutes;

    if (diff % _period != 0) {
      print("알림까지 ${_period - (diff % _period)}분 남았습니다");
      return false;
    }
    print("알림을 발송할 시각입니다.");
    return true;
  }

  bool isInAlertList(String parkId) {
    print("isInAlertList :"+parkId);
    print("isInAlertList :"+alert.parks.toString());
    for (int i=0; i<alert.parks.length; i++) {
      if (alert.parks[i] == parkId) {
        print("isInAlertList : return true");
        return true;
      }
    }
    return false;
  }
}

class Alert {
  final int periodType;
  final String startTime;
  final bool switchState;
  final List<String> parks;

  static Map<int, String> periodTypeToString = {0: "30분 마다", 1: "1시간 마다", 2: "1시간 30분 마다", 3: "2시간 마다", 4: "2시간 30분 마다", 5: "3시간 마다"};

  static Map<int, int> periodTypeToMinutes = {0: 30, 1: 60, 2: 90, 3: 120, 4: 150, 5: 180};

  //for debug
  // static Map<int, int> periodTypeToMinutes = {0: 1, 1: 2, 2: 3, 3: 4, 4: 5, 5: 6};

  Alert(this.periodType, this.startTime, this.switchState, [this.parks]);

  factory Alert.fromJson(Map<String, dynamic> json) {
    List<String> _data = List<String>.from(json['parks']);
    return Alert(
      json['periodType'],
      json['startTime'],
      json['switchState'],
      _data
    );
  }

  static Map<String, dynamic> toMap(Alert alert) => {
        'periodType': alert.periodType,
        'startTime': alert.startTime,
        'switchState': alert.switchState,
        'parks': alert.parks,
      };

  @override
  String toString() {
    return "{\"switchState\": $switchState, \"periodType\": $periodType, \"startTime\": $startTime, \"parks\": $parks}";
  }
}
