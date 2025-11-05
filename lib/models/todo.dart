class Todo {
  final int? id;
  final String description;
  final DateTime createdAt;


  Todo({this.id, required this.description, required this.createdAt});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'description': description,
      'created_at': createdAt.millisecondsSinceEpoch
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int,
      description: map['description'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'])
    );
  }

  @override
  String toString() {
    return 'Todo{id: $id, description: $description}';
  }
}