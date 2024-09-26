import 'dart:convert';
import 'package:http/http.dart' as http;

class Restauranthandler{
  List restaurantList = [];

  insertRestaurant(categoryId, userSeq, name, latitude, longitude, image, phone, represent, memo, favorite) async{
    var url = Uri.parse("http://127.0.0.1:8000/insert?catergory_id=$categoryId&user_seq=$userSeq&name=$name&latitude=$latitude&longitude=$longitude&image=$image&phone=$phone&represent=$represent&memo=$memo&favorite=$favorite");
    var response = await http.get(url);
    restaurantList.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];
    restaurantList.addAll(result);
  }

  Future<List<Restaurant>> findRestaurantCategory(String keyword) async {
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      """
        select 
              *
        from 
              restaurant 
        where 
              category like '%$keyword%' or name like '%$keyword%' or represent like '%$keyword%' or comment like '%$keyword%'
      """
    );
    return queryResult
        .map(
          (e) => Restaurant.fromMap(e),
        )
        .toList();
  }



}