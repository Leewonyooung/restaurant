import 'package:restaurant/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class Favoritehandler{
  Future<List<Restaurant>> queryRestaurant() async {
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      """
        select * from favorite
      """
    );
    return queryResult
        .map(
          (e) => Restaurant.fromMap(e),
        )
        .toList();
  }
  Future<int> insertFavoriteRestaurant(Restaurant restaurant) async {
    int result = 0;
    final Database db = await handler.initializeDB();
    result = await db.rawInsert(
        """
          insert into favorite(
            name, category, latitude, longitude, phone, represent, comment, image
          )
          values (?, ?, ?, ?, ?, ?, ?, ?)
        """,
        [
          restaurant.name,
          restaurant.group,
          restaurant.latitude,
          restaurant.longitude,
          restaurant.phone,
          restaurant.represent,
          restaurant.comment,
          restaurant.image
        ]
      );
      return result;
  }

  Future<int> deleteFavoriteRestaurant(int id) async {
    int result = 0;
    final Database db = await handler.initializeDB();
    result = await db.rawInsert(
        """
          delete from favorite
          where id = ?
        """,
        [
         id
        ]
      );
      return result;
  }
}