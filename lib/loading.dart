import 'dart:async';

import 'package:boombee/services/github_api/get_parks_info.dart';
import 'package:boombee/utils/alert.dart';
import 'package:boombee/utils/subscribe.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart' as globals;
import 'dart:convert';
import 'package:flutter/services.dart';

void loading() async {
  String categoryCityJsonString =
      await rootBundle.loadString('assets/static/category/city.json');
  globals.cityId2name = await json.decode(categoryCityJsonString);
  globals.cityId2name.forEach((key, value) {
    globals.cityIdList.add(key);
    globals.cityId2guIdList[key] = [];
  });

  globals.cityIdList.forEach((cityId) async {
    String categoryGuJsonString = await rootBundle
        .loadString('assets/static/category/gu/' + cityId + '.json');
    var guJson = await json.decode(categoryGuJsonString);
    guJson.forEach((key, value) {
      globals.cityId2guIdList[cityId].add(key);
      globals.guId2name[key] = value;
    });
  });

  globals.prefs = await SharedPreferences.getInstance();

  globals.subscribe = Subscribe();
  globals.subscribe.init();

  globals.alertManager = AlertManager();
  globals.alertManager.init();

  Map<String, Park> parksInfoMap = await fetchGetParksInfoMap();
  parksInfoMap.forEach((k, v) {
    globals.parkId2name[k] = v.name;
  });

  final initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final initSettings = InitializationSettings(
    android: initSettingsAndroid,
  );
  await globals.flutterLocalNotificationsPlugin.initialize(
    initSettings,
  );

  Timer.periodic(Duration(seconds: 10), (Timer t) => _showNotification());
}

Future<void> _showNotification() async {
  print("show notification called");
  if (!globals.alertManager.isSwitchOn()) return;
  if (!globals.alertManager.isTimeToAlert()) return;

  Map<String, Park> parksInfoMap = await fetchGetParksInfoMap();
  List<String> _alertParks = globals.alertManager.alert.parks;
  String text = "";

  for (int i = 0; i < _alertParks.length; i++) {
    String _parkId = _alertParks[i];
    String _name = parksInfoMap[_parkId].name;
    if (!parksInfoMap[_parkId].hasData()) {
      text += "$_name 데이터가 없습니다.";
      continue;
    }

    String _date = parksInfoMap[_parkId].getLatestDate();
    String _ad =
        parksInfoMap[_parkId].getLatestAverageDistance().toStringAsFixed(1);
    String _density =
        parksInfoMap[_parkId].getLatestDensity().toStringAsFixed(1);

    text += "$_name 인구 밀집도 $_density%, 사람 간 평균 거리 ${_ad}m입니다.";

    if (i != _alertParks.length - 1) {
      text += "\n";
    }
  }

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(text));

  print(text);
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await globals.flutterLocalNotificationsPlugin.show(
      0, '붐비', '공원 알림이 도착했습니다.', platformChannelSpecifics,
      payload: 'item x');
}
