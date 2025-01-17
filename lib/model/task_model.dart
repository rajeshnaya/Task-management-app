class Task {
  String id;
  String title;
  String description;
  bool isComplete;
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isComplete,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isComplete': isComplete ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isComplete: map['isComplete'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
