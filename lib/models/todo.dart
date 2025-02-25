class Todo {
  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
