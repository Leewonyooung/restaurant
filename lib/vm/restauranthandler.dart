import 'package:restaurant/model/restaurant.dart';
import 'package:restaurant/vm/init_restaurant.dart';
import 'package:sqflite/sqlite_api.dart';

class Restauranthandler{
  InitRestaurant handler = InitRestaurant();

  Future<List<Restaurant>> queryRestaurant() async {
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      """
        select * from restaurant 
      """
    );
    return queryResult
        .map(
          (e) => Restaurant.fromMap(e),
        )
        .toList();
  }

  Future<List<Restaurant>> queryRestaurantCategory() async {
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      """
        select distinct
              category 
        from 
              restaurant 
      """
    );
    return queryResult
        .map(
          (e) => Restaurant.categoryfromMap(e),
        )
        .toList();
  }


   Future<List<Restaurant>> searchRestaurantCategory(String keyword) async {
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      """
        select 
              *
        from 
              restaurant 
        where 
              category like '%$keyword%'
      """
    );
    return queryResult
        .map(
          (e) => Restaurant.fromMap(e),
        )
        .toList();
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


  Future<int> insertRestaurant(Restaurant restaurant) async {
    int result = 0;
    final Database db = await handler.initializeDB();
    result = await db.rawInsert(
        """
          insert into restaurant(
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

  Future<int> deleteRestaurant(int id) async {
    int result = 0;
    final Database db = await handler.initializeDB();
    result = await db.rawInsert(
        """
          delete from restaurant
          where id = ?
        """,
        [
         id
        ]
      );
      return result;
  }

  Future<int> updateRestaurant(Restaurant restaurant) async {
    int result = 0;
    final Database db = await handler.initializeDB();
    result = await db.rawUpdate(
        """
          update restaurant
          set
              name = ?,
              category = ?,
              latitude = ?,
              longitude = ?,
              phone = ?,
              represent = ?,
              comment = ?,
              image = ?
          where id = '${restaurant.id}'
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


}