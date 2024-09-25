import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class InitRestaurant {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'restaurantlist.db'),
      onCreate: (db, version) async {
        await db.execute(
          """
            CREATE TABLE restaurant (
            `id` integer primary key autoincrement,
            `name` varchar(45) DEFAULT NULL,
            `category` varchar(45) DEFAULT NULL,
            `latitude` double DEFAULT NULL,
            `longitude` double DEFAULT NULL,
            `phone` varchar(45) DEFAULT NULL,
            `represent` varchar(45) DEFAULT NULL,
            `comment` varchar(45) DEFAULT NULL,
            `image` blob DEFAULT NULL
            )
        """
        );
        await db.execute(
          """
            CREATE TABLE favorite (
            `id` integer primary key autoincrement,
            `name` varchar(45) DEFAULT NULL,
            `category` varchar(45) DEFAULT NULL,
            `latitude` double DEFAULT NULL,
            `longitude` double DEFAULT NULL,
            `phone` varchar(45) DEFAULT NULL,
            `represent` varchar(45) DEFAULT NULL,
            `comment` varchar(45) DEFAULT NULL,
            `image` blob DEFAULT NULL
            )
        """
        );
      },
      version: 1,
    );
  }
}
