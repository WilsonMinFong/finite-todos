class Todo {
  final int? id;
  final String description;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool inProgress;

  // TODO: Make this number configurable
  static const int maxNumInProgress = 4;
  static const int expireDays = 7;
  static const int expireMinutes = expireDays * 24 * 60;

  Todo({
    this.id,
    required this.description,
    required this.createdAt,
    this.completedAt,
    required this.inProgress
  });

  Todo toggleComplete() {
    return copyWith(
      completedAt: completedAt == null ? DateTime.now() : null,
      inProgress: false
    );
  }

  Todo toggleInProgress() {
    return copyWith(
      inProgress: !inProgress
    );
  }

  Todo copyWith({int? id, String? description, DateTime? createdAt, DateTime? completedAt, bool? inProgress}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt != this.completedAt ? completedAt : this.completedAt,
      inProgress: inProgress ?? this.inProgress,
    );
  }

  DateTime get expiresAt {
    return createdAt.add(Duration(minutes: expireMinutes));
  }

  bool get isExpired {
    return DateTime.now().isAfter(expiresAt) &&
           completedAt == null &&
           !inProgress;
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'description': description,
      'created_at': createdAt.millisecondsSinceEpoch,
      'completed_at': completedAt?.millisecondsSinceEpoch,
      'in_progress': inProgress
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int,
      description: map['description'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      completedAt: map['completed_at'] != null ? DateTime.fromMillisecondsSinceEpoch(map['completed_at']) : null,
      inProgress: map['in_progress'] == 1
    );
  }

  @override
  String toString() {
    return 'Todo{id: $id, description: $description}';
  }
}