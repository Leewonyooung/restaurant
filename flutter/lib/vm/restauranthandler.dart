import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/model/restaurant.dart';

class Restauranthandler{

  insertRestaurant(Restaurant restaurant) async{
    var url = Uri.parse("http://127.0.0.1:8000/insert/restaurant?categoryId=${restaurant.category_id}&userSeq=${restaurant.user_seq}&name=${restaurant.name}&latitude=${restaurant.latitude}&longitude=${restaurant.longitude}&image=${restaurant.image}&phone=${restaurant.phone}&represent=${restaurant.represent}&memo=${restaurant.memo}&favorite=${restaurant.favorite? 1 : 0}");
    var response = await http.get(url);

    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];

    return result;
  }


  Future<List> getAllRestaurant() async{
    var url = Uri.parse("http://127.0.0.1:8000/read/");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    print(result[0]['image']);
    return result;
  }

  Future<List> getRestaurantbyC(String category) async{
    var url = Uri.parse("http://127.0.0.1:8000/read/bycategory?keyword=$category");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];
    return result.map(
      (e) => Restaurant.fromMap(e)
    ).tolist();
  }

  Future<List> deleteRestaurant(int seq, int user_seq) async{
    var url = Uri.parse("http://127.0.0.1:8000/delete?seq=$seq&user_seq=$user_seq");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];
    return result.map(
      (e) => Restaurant.fromMap(e)
    ).tolist();
  }

    Future<List>findRestaurantCategory(String keyword) async {
    var url = Uri.parse("http://127.0.0.1:8000/read/bykeyword?keyword=$keyword");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    return result.map((e) => Restaurant.fromMap(e),).toList();
  }


}