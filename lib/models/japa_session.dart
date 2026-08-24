/// Immutable domain model for a single counting session.
///
/// Matches the `japa_sessions` table schema (version 3).
/// Append-only — never modified after creation.
/// Pure Dart — no Flutter or sqflite imports.
class JapaSession {
  final String id;
  final String counterId;
  final String counterName;
  final int count;
  final int malas; // count ÷ 108
  final int chants; // count % 108
  final int timestamp; // epoch ms
  final int duration; // ms

  const JapaSession({
    required this.id,
    required this.counterId,
    required this.counterName,
    required this.count,
    required this.malas,
    required this.chants,
    required this.timestamp,
    required this.duration,
  });

  JapaSession copyWith({
    String? id,
    String? counterId,
    String? counterName,
    int? count,
    int? malas,
    int? chants,
    int? timestamp,
    int? duration,
  }) => JapaSession(
    id: id ?? this.id,
    counterId: counterId ?? this.counterId,
    counterName: counterName ?? this.counterName,
    count: count ?? this.count,
    malas: malas ?? this.malas,
    chants: chants ?? this.chants,
    timestamp: timestamp ?? this.timestamp,
    duration: duration ?? this.duration,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'counterId': counterId,
    'counterName': counterName,
    'count': count,
    'malas': malas,
    'chants': chants,
    'timestamp': timestamp,
    'duration': duration,
  };

  factory JapaSession.fromMap(Map<String, dynamic> map) => JapaSession(
    id: map['id'] as String,
    counterId: map['counterId'] as String,
    counterName: map['counterName'] as String,
    count: map['count'] as int,
    malas: map['malas'] as int? ?? 0,
    chants: map['chants'] as int? ?? 0,
    timestamp: map['timestamp'] as int,
    duration: map['duration'] as int? ?? 0,
  );

  /// JSON serialisation — must be compatible with Android Gson export format.
  Map<String, dynamic> toJson() => {
    'id': id,
    'counterId': counterId,
    'counterName': counterName,
    'count': count,
    'malas': malas,
    'chants': chants,
    'timestamp': timestamp,
    'duration': duration,
  };

  factory JapaSession.fromJson(Map<String, dynamic> json) => JapaSession(
    id: json['id'] as String,
    counterId: json['counterId'] as String,
    counterName: json['counterName'] as String,
    count: (json['count'] as num).toInt(),
    malas: (json['malas'] as num?)?.toInt() ?? 0,
    chants: (json['chants'] as num?)?.toInt() ?? 0,
    timestamp: (json['timestamp'] as num).toInt(),
    duration: (json['duration'] as num?)?.toInt() ?? 0,
  );
}
