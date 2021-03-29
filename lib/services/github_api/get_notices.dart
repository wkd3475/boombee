import 'dart:convert';
import 'package:http/http.dart' as http;

//공지사항을 불러오는 기능
Future<List<Notice>> fetchNotices() async {
  final response =
  await http.get('http://wjddls1771.github.io/boombee/get_notices.json');

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
    return NoticeList.fromJson(json.decode(response.body)).notices;
  } else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load notices');
  }
}

class Notice {
  final String title;
  final String body;

  Notice({this.title, this.body});

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      title: json['title'],
      body: json['body'],
    );
  }
}

class NoticeList {
  final List<Notice> notices;

  NoticeList([this.notices]);

  factory NoticeList.fromJson(Map<String, dynamic> json) {
    var dataObjsJson = json['notices'] as List;
    List _data = dataObjsJson.map((dataJson) => Notice.fromJson(dataJson)).toList();
    return NoticeList(_data);
  }
}