class Todo {
  final int? id;
  final String description;
  final DateTime createdAt;
  final DateTime? completedAt;


  Todo({
    this.id,
    required this.description,
    required this.createdAt,
    this.completedAt
  });

  Todo toggleComplete() {
    return copyWith(
      id: id,
      description: description,
      createdAt: createdAt,
      completedAt: completedAt == null ? DateTime.now() : null
    );
  }

  Todo copyWith({int? id, String? description, DateTime? createdAt, DateTime? completedAt}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt != this.completedAt ? completedAt : this.completedAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'description': description,
      'created_at': createdAt.millisecondsSinceEpoch,
      'completed_at': completedAt?.millisecondsSinceEpoch
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int,
      description: map['description'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      completedAt: map['completed_at'] != null ? DateTime.fromMillisecondsSinceEpoch(map['completed_at']) : null
    );
  }

  @override
  String toString() {
    return 'Todo{id: $id, description: $description}';
  }
}