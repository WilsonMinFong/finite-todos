class Todo {
  final int? id;
  final String description;


  Todo({this.id, required this.description});

  Map<String, Object?> toMap() {
    return {'id': id, 'description': description};
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int,
      description: map['description'] as String,
    );
  }

  @override
  String toString() {
    return 'Todo{id: $id, description: $description}';
  }
}