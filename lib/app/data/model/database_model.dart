class Database {
  final String id;
  final String title;

  Database({required this.id, required this.title});

  factory Database.fromMap(Map<String, dynamic> map){
    final id = map['id'];
    final titleList = (map['title'] ?? []) as List;

    return Database(
      id: id,
      title: titleList.isNotEmpty ? titleList[0]['plain_text'] : '(?) Untitled'
    );
  }
}
