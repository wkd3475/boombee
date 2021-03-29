import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Corona> fetchCorona() async {
  final response =
  await http.get('https://api.corona-19.kr/korea/country/new/?serviceKey=EHd1kTFOoReAwKb7WqvNi62mBD3scnuPj');
//만약 키가 만료되면 위 페이지에서 다시 발급받아서 설정하면 됨.
  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
    return Corona.fromJson(json.decode(response.body));
  } else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

class Country {
  final String countryName;
  final String newCase;
  final String totalCase;

  Country({this.countryName, this.newCase, this.totalCase});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryName: json['countryName'],
      newCase: json['newCase'],
      totalCase: json['totalCase'],
    );
  }
}

class Corona {
  final Country korea;
  final Country seoul;
  final Country busan;
  final Country daegu;
  final Country incheon;
  final Country gwangju;
  final Country daejeon;
  final Country ulsan;
  final Country sejong;
  final Country gyeonggi;
  final Country gangwon;
  final Country chungbuk;
  final Country chungnam;
  final Country jeonbuk;
  final Country jeonnam;
  final Country gyeongbuk;
  final Country gyeongnam;
  final Country jeju;

  Corona({this.seoul, this.busan, this.daegu,
  this.incheon, this.gwangju, this.daejeon,
  this.ulsan, this.sejong, this.gyeonggi,
  this.gangwon, this.chungbuk, this.chungnam,
  this.jeonbuk, this.jeonnam, this.gyeongbuk,
  this.gyeongnam, this.jeju, this.korea});

  factory Corona.fromJson(Map<String, dynamic> json) {
    return Corona(
      korea: Country.fromJson(json['korea']),
      seoul: Country.fromJson(json['seoul']),
      busan: Country.fromJson(json['busan']),
      daegu: Country.fromJson(json['daegu']),
      incheon: Country.fromJson(json['incheon']),
      gwangju: Country.fromJson(json['gwangju']),
      daejeon: Country.fromJson(json['daejeon']),
      ulsan: Country.fromJson(json['ulsan']),
      sejong: Country.fromJson(json['sejong']),
      gyeonggi: Country.fromJson(json['gyeonggi']),
      gangwon: Country.fromJson(json['gangwon']),
      chungbuk: Country.fromJson(json['chungbuk']),
      chungnam: Country.fromJson(json['chungnam']),
      jeonbuk: Country.fromJson(json['jeonbuk']),
      jeonnam: Country.fromJson(json['jeonnam']),
      gyeongbuk: Country.fromJson(json['gyeongbuk']),
      gyeongnam: Country.fromJson(json['gyeongnam']),
      jeju: Country.fromJson(json['jeju']),
    );
  }
}

