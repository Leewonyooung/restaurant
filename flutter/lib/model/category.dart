class Category {
  late String id;

  Category(
    {
      required this.id,
    }
  );

  Category.fromMap(Map res):
    id = res['id'][0];
}