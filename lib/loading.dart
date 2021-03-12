import 'package:boombee/services/github_api/get_parks_info.dart';
import 'package:boombee/utils/alert.dart';
import 'package:boombee/utils/subscribe.dart';
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
}
