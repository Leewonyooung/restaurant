import 'dart:typed_data';

class Restaurant{
  int? id;
  late String name;
  late String group;
  late double latitude;
  late double longitude;
  late String phone;
  late String represent;
  late String comment;
  late Uint8List image;

  Restaurant(
    {
      this.id,
      required this.name,
      required this.group,
      required this.latitude,
      required this.longitude,
      required this.phone,
      required this.represent,
      required this.comment,
      required this.image,
    }
  );

  Restaurant.category({
    this.id,
    required this.group,
  });

  Restaurant.categoryfromMap(Map<String, dynamic> res):
    group = res['category'];


  Restaurant.fromMap(Map<String, dynamic> res):
    id = res['id'],
    name = res['name'],
    group = res['category'],
    latitude = res['latitude'],
    longitude =  res['longitude'],
    phone = res['phone'],
    represent = res['represent'],
    comment = res['comment'],
    image = res['image'];
}