import '../globals.dart' as globals;
import 'dart:convert';

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
    DateTime now = DateTime.now();
    DateTime _startTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);
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

    Alert newAlert = Alert(alert.periodType, alert.startTime, alert.isSwitchOn, content);

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

    Alert newAlert = Alert(alert.periodType, alert.startTime, alert.isSwitchOn, content);

    globals.prefs.setString(keyAlert, json.encode(Alert.toMap(newAlert)));
    alert = newAlert;
    print("remove alert : "+alert.toString());
  }

  void updatePeriod(int periodType) {
    Alert newAlert = Alert(periodType, alert.startTime, alert.isSwitchOn, alert.parks);

    globals.prefs.setString(keyAlert, json.encode(Alert.toMap(newAlert)));
    alert = newAlert;
    print("update alert period : $alert");
  }

  void switchOn() {
    Alert newAlert = Alert(alert.periodType, alert.startTime, true, alert.parks);
    globals.prefs.setString(keyAlert, json.encode(Alert.toMap(newAlert)));
    alert = newAlert;
    print("alert switch on");
  }

  void switchOff() {
    Alert newAlert = Alert(alert.periodType, alert.startTime, false, alert.parks);
    globals.prefs.setString(keyAlert, json.encode(Alert.toMap(newAlert)));
    alert = newAlert;
    print("alert switch off");
  }
}

class Alert {
  final int periodType;
  final String startTime;
  final bool isSwitchOn;
  final List<String> parks;

  static Map<int, String> periodTypeToString = {0: "30분 마다", 1: "1시간 마다", 2: "1시간 30분 마다", 3: "2시간 마다", 4: "2시간 30분 마다", 5: "3시간 마다"};

  Alert(this.periodType, this.startTime, this.isSwitchOn, [this.parks]);

  factory Alert.fromJson(Map<String, dynamic> json) {
    List<String> _data = List<String>.from(json['parks']);
    return Alert(
      json['periodType'],
      json['startTime'],
      json['isSwitchOn'],
      _data
    );
  }

  static Map<String, dynamic> toMap(Alert alert) => {
        'periodType': alert.periodType,
        'startTime': alert.startTime,
        'isSwitchOn': alert.isSwitchOn,
        'parks': alert.parks,
      };



  @override
  String toString() {
    return "{\"isSwitchOn\": $isSwitchOn, \"periodType\": $periodType, \"startTime\": $startTime, \"parks\": $parks}";
  }
}
