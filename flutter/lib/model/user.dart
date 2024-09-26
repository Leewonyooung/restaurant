class User {
  int? seq;
  late String id;

  User(
    {
      this.seq,
      required this.id,
    }
  );

  User.fromMap(Map<String, dynamic> res):
    seq = int.parse(res['seq']),
    id = res['id'];
}