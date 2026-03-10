class Habit {
  const Habit({
    required this.id,
    required this.userEmail,
    required this.name,
    this.records = const [],
  });

  factory Habit.fromMap(Map<String, dynamic> map, {String? id}) {
    return Habit(
      id: id ?? map['id'] as String? ?? '',
      userEmail: map['userEmail'] as String? ?? '',
      name: map['name'] as String? ?? '',
      records:
          (map['records'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          const [],
    );
  }

  final String id;
  final String userEmail;
  final String name;
  final List<DateTime> records;

  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'name': name,
      'records': records.map((d) => d.toIso8601String()).toList(),
    };
  }

  Habit copyWith({
    String? id,
    String? userEmail,
    String? name,
    List<DateTime>? records,
  }) {
    return Habit(
      id: id ?? this.id,
      userEmail: userEmail ?? this.userEmail,
      name: name ?? this.name,
      records: records ?? this.records,
    );
  }

  bool hasRecordOn(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return records.any((r) {
      final rDay = DateTime(r.year, r.month, r.day);
      return rDay == day;
    });
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Habit || runtimeType != other.runtimeType) return false;
    if (id != other.id ||
        userEmail != other.userEmail ||
        name != other.name ||
        records.length != other.records.length) {
      return false;
    }
    for (var i = 0; i < records.length; i++) {
      if (records[i] != other.records[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode =>
      id.hashCode ^ userEmail.hashCode ^ name.hashCode ^ records.hashCode;
}
