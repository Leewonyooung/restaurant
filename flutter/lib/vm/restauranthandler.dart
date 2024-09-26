import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/model/restaurant.dart';

class Restauranthandler{

  insertRestaurant(Restaurant restaurant) async{


    var url = Uri.parse("http://127.0.0.1:8000/insert?catergory_id=${restaurant.category_id}&user_seq=${restaurant.user_seq}&name=${restaurant.name}&latitude=${restaurant.latitude}&longitude=${restaurant.longitude}&image=${restaurant.image}&phone=${restaurant.phone}&represent=${restaurant.represent}&memo=${restaurant.memo}&favorite=${restaurant.favorite? 1 : 0}");
    var response = await http.get(url);

    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];

    return result.map(
      (e) => Restaurant.fromMap(e)
    ).tolist();
  }

  // Future<List<Restaurant>> findRestaurantCategory(String keyword) async {
  //   final Database db = await handler.initializeDB();
  //   final List<Map<String, Object?>> queryResult = await db.rawQuery(
  //     """
  //       select 
  //             *
  //       from 
  //             restaurant 
  //       where 
  //             category like '%$keyword%' or name like '%$keyword%' or represent like '%$keyword%' or comment like '%$keyword%'
  //     """
  //   );
  //   return queryResult
  //       .map(
  //         (e) => Restaurant.fromMap(e),
  //       )
  //       .toList();
  // }



}