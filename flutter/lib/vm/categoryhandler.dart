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
    // categoryList.addAll(result);
  }
}