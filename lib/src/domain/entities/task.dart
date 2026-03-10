class Task {
  const Task({
    required this.id,
    required this.userEmail,
    required this.name,
    this.spendTime = 0,
    this.isDone = false,
    this.isPriority = false,
    this.completedAt,
  });

  factory Task.fromMap(Map<String, dynamic> map, {String? id}) {
    return Task(
      id: id ?? map['id'] as String? ?? '',
      userEmail: map['userEmail'] as String? ?? '',
      name: map['name'] as String? ?? '',
      spendTime: map['spendTime'] as int? ?? 0,
      isDone: map['isDone'] as bool? ?? false,
      isPriority: map['isPriority'] as bool? ?? false,
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'] as String)
          : null,
    );
  }

  final String id;
  final String userEmail;
  final String name;
  final int spendTime;
  final bool isDone;
  final bool isPriority;
  final DateTime? completedAt;

  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'name': name,
      'spendTime': spendTime,
      'isDone': isDone,
      'isPriority': isPriority,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  Task copyWith({
    String? id,
    String? userEmail,
    String? name,
    int? spendTime,
    bool? isDone,
    bool? isPriority,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      userEmail: userEmail ?? this.userEmail,
      name: name ?? this.name,
      spendTime: spendTime ?? this.spendTime,
      isDone: isDone ?? this.isDone,
      isPriority: isPriority ?? this.isPriority,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Task || runtimeType != other.runtimeType) return false;
    return id == other.id &&
        userEmail == other.userEmail &&
        name == other.name &&
        spendTime == other.spendTime &&
        isDone == other.isDone &&
        isPriority == other.isPriority &&
        completedAt == other.completedAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      userEmail.hashCode ^
      name.hashCode ^
      spendTime.hashCode ^
      isDone.hashCode ^
      isPriority.hashCode ^
      completedAt.hashCode;
}
