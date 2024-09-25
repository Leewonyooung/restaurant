import 'dart:convert';

import 'package:http/http.dart' as http;

class Categoryhandler {
  List<String> categoryList = [];
  getCategory(String keyword) async {
    var url = Uri.parse("http://127.0.0.1:8000/read/category");
    var response = await http.get(url);
    categoryList.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];
    categoryList.addAll(result);
  }
}