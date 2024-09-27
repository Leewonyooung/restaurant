class Restaurant{
  int? seq;
  late String categoryId;
  late int userSeq;
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
      required this.categoryId,
      required this.userSeq,
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

  Restaurant.fromMap(Map<dynamic, dynamic> res):
    seq = res['seq'],
    categoryId = res['category_id'],
    userSeq = res['user_seq'],
    name = res['name'],
    latitude = res['latitude'],
    longitude =  res['longitude'],
    image =  res['image'],
    phone = res['phone'],
    represent = res['represent'],
    memo = res['memo'],
    favorite = res['favorite'] == 1;
}