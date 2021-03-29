library boombee.globals;

import 'package:boombee/utils/alert.dart';
import 'package:boombee/utils/subscribe.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

//알림 기능을 위한 플러그인
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

//assets/static에서 저장된 값을 저장해서 사용함. 저장하는 부분은 loading.dart에 위치함
List<String> cityIdList = [];// city id의 list를 저장 => 카테고리 출력
Map cityId2name = {};// city id를 해당하는 city name으로 변환
Map<String, List<String>> cityId2guIdList = {};// city id에 해당하는 gu의 list를 저장
Map guId2name = {};// gu id를 해당하는 gu name으로 변환
Map<String, String> parkId2name = {};

Subscribe subscribe;

AlertManager alertManager;

SharedPreferences prefs;