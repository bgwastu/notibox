class Database {
  final String id;
  final String title;

  Database({required this.id, required this.title});

  factory Database.fromMap(Map<String, dynamic> map) {
    final id = map['id'] as String;
    final titleList = (map['title'] ?? []) as List<dynamic>;

    return Database(
        id: id,
        title: titleList.isNotEmpty
            ? titleList[0]['plain_text'] as String
            : '(?) Untitled');
  }
}
