import '../globals.dart' as globals;
import 'dart:convert';

class AlertManager {
  String key = "alert";
  List<Alert> alertList = [];

  Future<String> getAlert() async {
    return globals.prefs.getString(key);
  }

  void init() async {
    var data = await getAlert();
    if (data != null) {
      alertList = Alert.decode(data);
      return;
    } else {
      alertList = [];
    }
    print("init alert : "+alertList.toString());
  }

  void add(Alert alert) {
    DateTime now = DateTime.now();
    DateTime _startTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    List<Alert> content = alertList;
    bool hasParkId = false;

    for (var i = 0; i < content.length; i++) {
      if (content[i].parkId == alert.parkId) {
        hasParkId = true;
      }
    }

    if (!hasParkId) {
      content.add(Alert(parkId: alert.parkId, periodType: alert.periodType, startTime: _startTime.toString()));
    }

    globals.prefs.setString(key, Alert.encode(content));
    alertList = content;
    print("add alert : "+alertList.toString());
  }

  void remove(String parkId) {
    List<Alert> content = alertList;
    bool hasParkId = false;

    for (var i = 0; i < content.length; i++) {
      if (content[i].parkId == parkId) {
        content.removeAt(i);
        hasParkId = true;
      }
    }

    if (!hasParkId) return;

    globals.prefs.setString(key, Alert.encode(content));
    alertList = content;
    print("remove alert : "+alertList.toString());
  }

  void update(Alert alert, int periodType) {
    List<Alert> content = alertList;
    Alert newAlert = Alert(parkId: alert.parkId, periodType: periodType, startTime: alert.startTime);
    bool hasParkId = false;
    print("update alert $newAlert");

    for (var i = 0; i < content.length; i++) {
      if (content[i].parkId == alert.parkId) {
        content[i] = newAlert;
        hasParkId = true;
        globals.prefs.setString(key, Alert.encode(content));
      }
    }

    if (hasParkId == false) {
      print("no such alert");
    }
  }
}

class Alert {
  final String parkId;
  final String startTime;
  final int periodType;

  Alert({this.parkId, this.periodType, this.startTime});

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      parkId: json['parkId'],
      periodType: json['periodType'],
      startTime: json['startTime'],
    );
  }

  static Map<String, dynamic> toMap(Alert alert) => {
        'parkId': alert.parkId,
        'periodType': alert.periodType,
        'startTime': alert.startTime,
      };

  static String encode(List<Alert> alerts) => json.encode(
        alerts
            .map<Map<String, dynamic>>((alert) => Alert.toMap(alert))
            .toList(),
      );

  static List<Alert> decode(String alerts) =>
      (json.decode(alerts) as List<dynamic>)
          .map<Alert>((item) => Alert.fromJson(item))
          .toList();

  @override
  String toString() {
    return "{\"parkId\": \"$parkId\", \"periodType\": $periodType, \"startTime\": $startTime}";
  }
}
