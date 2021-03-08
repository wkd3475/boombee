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
}
