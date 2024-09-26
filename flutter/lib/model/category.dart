class Category {
  late String id;

  Category(
    {
      required this.id,
    }
  );

  Category.fromMap(Map<String, dynamic> res):
    id = res['id'][0];
}