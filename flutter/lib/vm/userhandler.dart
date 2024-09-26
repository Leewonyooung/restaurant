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
    print(result[0]);
    return result[0][0].toString();
  }
}