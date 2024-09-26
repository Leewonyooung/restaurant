

class Restaurant{
  int? seq;
  late String category_id;
  late int user_seq;
  late String name;
  late double latitude;
  late double longitude;
  late String image;
  late String phone;
  late String represent;
  late String memo;
  late bool favorite;

  Restaurant(
    {
      this.seq,
      required this.category_id,
      required this.user_seq,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.image,
      required this.phone,
      required this.represent,
      required this.memo,
      required this.favorite,
    }
  );

  Restaurant.fromMap(Map<String, dynamic> res):
    seq = res['seq'],
    category_id = res['category_id'],
    user_seq = res['user_seq'],
    name = res['name'],
    latitude = res['latitude'],
    longitude =  res['longitude'],
    image =  res['image'],
    phone = res['phone'],
    represent = res['represent'],
    memo = res['memo'],
    favorite = res['favorite'] == 1;
}