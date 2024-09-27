/*
Fixed: 2024.09.26.
Usage: 맛집 핸들러
*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/model/restaurant.dart';


class Restauranthandler{
  /*
  author: 박상범
  Fixed: 2024.09.26.
  Usage: 맛집 추가하기
  */
  insertRestaurant(Restaurant restaurant) async{
    var url = Uri.parse("http://127.0.0.1:8000/insert/restaurant?categoryId=${restaurant.categoryId}&userSeq=${restaurant.userSeq}&name=${restaurant.name}&latitude=${restaurant.latitude}&longitude=${restaurant.longitude}&image=${restaurant.image}&phone=${restaurant.phone}&represent=${restaurant.represent}&memo=${restaurant.memo}&favorite=${restaurant.favorite? 1 : 0}");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];
    return result;
  }


  /*
  author: 이원영
  Fixed: 2024.09.26.
  Usage: 전체 맛집 불러오기
  */
  Future<List> getAllRestaurant() async{
    var url = Uri.parse("http://127.0.0.1:8000/read/");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    return result.map((e) => Restaurant.fromMap(e),).toList();
  }



  /*
  author: 박상범
  Fixed: 2024.09.26.
  Usage: 레스토랑 지우기
  */

  deleteRestaurant(int seq, int userSeq) async{
    var url = Uri.parse("http://127.0.0.1:8000/delete?seq=$seq&user_seq=$userSeq");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];
    return result;
  }

  /*
  author: 이원영
  Fixed: 2024.09.26.
  Usage: 레스토랑
  */
  Future<List>findRestaurantCategory(String keyword) async {
    var url = Uri.parse("http://127.0.0.1:8000/read/bykeyword?keyword=$keyword");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    return result.map((e) => Restaurant.fromMap(e),).toList();
  }

  /*
  author: 박상범
  Fixed: 2024.09.26.
  Usage: 즐겨찾기한 레스토랑 찾기
  */
  Future<List>findRestaurantFVR() async {
    var url = Uri.parse("http://127.0.0.1:8000/read/favorite?favorite=1");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    return result.map((e) => Restaurant.fromMap(e),).toList();
  }
}