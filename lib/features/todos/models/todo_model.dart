class Todo {
  final String id;
  String title;
  bool isCompleted;

  Todo({required this.id, required this.title, this.isCompleted = false});

  factory Todo.fromJson(String id, Map<String, dynamic> json) {
    return Todo(
      id: id,
      title: json['title'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'isCompleted': isCompleted};
  }
}
