/*
author: 이원영
Description: 
Fixed: 2024.09.26.
Usage: 카테고리 드랍다운 버튼 밸류 저장용 핸들러
*/
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/model/category.dart';

class Categoryhandler {
  Future<List<Category>> getCategory() async {
    List<String> categoryList = [];
    var url = Uri.parse("http://127.0.0.1:8000/read/category");
    var response = await http.get(url);
    categoryList.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];  
    return result.map((e) => Category.fromMap(e)).toList();
  }
}