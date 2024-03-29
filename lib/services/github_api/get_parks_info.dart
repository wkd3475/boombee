import 'dart:convert';
import 'package:http/http.dart' as http;

//모든 공원의 데이터를 한번에 불러와서 map 형태로 저장
Future<Map<String, Park>> fetchGetParksInfoMap() async {
  final response =
  await http.get('http://wjddls1771.github.io/boombee/get_parks_info.json');

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
    print(json.decode(response.body));
    var dataObjsJson = json.decode(response.body)['parks'] as List;
    List _data = dataObjsJson.map((dataJson) => Park.fromJson(dataJson)).toList();
    Map<String, Park> id2data = {};
    for (int i=0; i<_data.length; i++) {
      id2data[_data[i].id] = _data[i];
    }
    return id2data;
  } else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

Future<List<Park>> fetchGetParksInfoList() async {
  final response =
  await http.get('http://wjddls1771.github.io/boombee/get_parks_info.json');

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
    var dataObjsJson = json.decode(response.body)['parks'] as List;
    List<Park> _data = dataObjsJson.map((dataJson) => Park.fromJson(dataJson)).toList();
    return _data;
  } else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

// 공원 하나에 대한 데이터를 불러오고자 할 때는 아래 함수의 주석을 지우고 사용하면 됨
// Future<Park> fetchGetParkInfo(String parkId) async {
//   final response =
//   await http.get('http://wjddls1771.github.io/boombee/get_park_info/$parkId.json');
//
//   if (response.statusCode == 200) {
//     // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
//     return Park.fromJson(json.decode(response.body));
//   } else {
//     // 만약 요청이 실패하면, 에러를 던집니다.
//     throw Exception('Failed to load post');
//   }
// }

class ParkData {
  final String date;
  final double density;
  final double averageDistance;

  ParkData({this.date, this.density, this.averageDistance});

  factory ParkData.fromJson(Map<String, dynamic> json) {
    return ParkData(
      date: json['date'],
      density: json['density'],
      averageDistance: json['average_distance']
    );
  }

  @override
  String toString() {
    return '{${this.date}, ${this.density}, ${this.averageDistance}}';
  }
}

class Park {
  final String id;
  final String name;
  final String location;
  final double latitude;
  final double longitude;
  final int radius;
  final String telephone;
  final String hour;
  final String website;
  final List<ParkData> data;

  Park(this.id, this.name, this.location,
        this.latitude, this.longitude, this.radius,
        this.telephone, this.hour, this.website,
        [this.data]);

  factory Park.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      var dataObjsJson = json['data'] as List;
      List _data = dataObjsJson.map((dataJson) => ParkData.fromJson(dataJson)).toList();
      return Park(
          json['id'],
          json['name'],
          json['location'],
          json['latitude'],
          json['longitude'],
          json['radius'],
          json['telephone'],
          json['hour'],
          json['website'],
          _data
      );
    } else {
      return Park(
          json['id'],
          json['name'],
          json['location'],
          json['latitude'],
          json['longitude'],
          json['radius'],
          json['telephone'],
          json['hour'],
          json['website'],
      );
    }
  }

  @override
  String toString() {
    return '{${this.id}, ${this.name}, ${this.location}, ${this.latitude}, ${this.longitude}, ${this.radius}, ${this.telephone}, ${this.hour}, ${this.website}, ${this.data}}';
  }

  double getDensityByDate(int year, int month, int day, int hour) {
    for (int i=0; i<this.data.length; i++) {

      DateTime _dt = DateTime.parse(this.data[i].date);
      if (_dt.year == year && _dt.month == month && _dt.day == day && _dt.hour == hour) {
        return this.data[i].density;
      }
    }
    return -1.0;
  }

  double getLatestDensity() {
    if (this.data.isEmpty) {
      return 100.0;
    }
    return this.data[this.data.length-1].density;
  }

  double getLatestAverageDistance() {
    if (this.data.isEmpty) {
      return -1;
    }
    return this.data[this.data.length-1].averageDistance;
  }

  List getLocation() {
    return [this.latitude, this.longitude];
  }

  String getLatestDate() {
    if (this.data.isEmpty) {
      return "-1";
    }
    return this.data[this.data.length-1].date;
  }

  bool hasData() {
    if (this.data.isEmpty)
      return false;
    return true;
  }
}