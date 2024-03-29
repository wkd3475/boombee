import 'dart:convert';
import 'package:http/http.dart' as http;

//각 구에 어떤 공원들이 속해있는지를 불러옴
Future<List<String>> fetchSearchByGu(String guId) async {
  final response =
  await http.get('http://wjddls1771.github.io/boombee/search_by_gu.json');

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
    return List<String>.from(json.decode(response.body)[guId]);
  } else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}