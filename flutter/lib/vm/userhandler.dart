/*
author: 이원영
Fixed: 2024.09.26.
Usage: 자동 로그인 핸들러
*/
import 'dart:convert';
import 'package:http/http.dart' as http;

class Userhandler {
  Future<String> initUser() async {
    var url = Uri.parse("http://127.0.0.1:8000/login/");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    return result;
  }
  
  Future<String> getSeq(id) async {
    var url = Uri.parse("http://127.0.0.1:8000/login/seq?id=$id");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    return result[0][0].toString();
  }
}