import '../globals.dart' as globals;

class AlertSwitchState {
  String key = "alert_switch";
  bool isSwitchOn = true;

  Future<bool> fetchAlertSwitchState() async {
    return globals.prefs.getBool(key);
  }

  bool getState() {
    return isSwitchOn;
  }

  void init() async {
    var data = await fetchAlertSwitchState();
    if (data != null) {
      isSwitchOn = data;
    }
    print("init alert : "+isSwitchOn.toString());
  }

  void switchOn() {
    isSwitchOn = true;

    globals.prefs.setBool(key, isSwitchOn);
    print("alert switch on");
  }

  void switchOff() {
    isSwitchOn = false;

    globals.prefs.setBool(key, isSwitchOn);
    print("alert switch off");
  }
}