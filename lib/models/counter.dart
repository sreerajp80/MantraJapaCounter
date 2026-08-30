import 'counter_status.dart';

/// Immutable domain model for a named mantra counter.
///
/// Matches the `counters` table schema (version 3).
/// Pure Dart — no Flutter or sqflite imports.
class Counter {
  final String id;
  final String name;
  final int initialCount;
  final int incrementStep;
  final int goal; // 0 = no lifetime goal
  final int dailyGoal; // 0 = no daily goal
  final int startDate; // epoch ms
  final int createdAt; // epoch ms
  final CounterStatus status;
  final int? disabledAt; // epoch ms; null if active
  final String? disabledReason;
  final bool isLocked;

  const Counter({
    required this.id,
    required this.name,
    this.initialCount = 0,
    this.incrementStep = 1,
    this.goal = 0,
    this.dailyGoal = 0,
    required this.startDate,
    required this.createdAt,
    this.status = CounterStatus.active,
    this.disabledAt,
    this.disabledReason,
    this.isLocked = false,
  });

  bool get hasLifetimeGoal => goal > 0;
  bool get hasDailyGoal => dailyGoal > 0;
  bool get isActive => status == CounterStatus.active;

  double lifetimeProgress(int totalCount) {
    if (!hasLifetimeGoal) return 0.0;
    return (totalCount / goal).clamp(0.0, 1.0);
  }

  double dailyProgress(int todayCount) {
    if (!hasDailyGoal) return 0.0;
    return (todayCount / dailyGoal).clamp(0.0, 1.0);
  }

  bool isLifetimeGoalAchieved(int totalCount) =>
      hasLifetimeGoal && totalCount >= goal;
  bool isDailyGoalAchieved(int todayCount) =>
      hasDailyGoal && todayCount >= dailyGoal;

  Counter copyWith({
    String? id,
    String? name,
    int? initialCount,
    int? incrementStep,
    int? goal,
    int? dailyGoal,
    int? startDate,
    int? createdAt,
    CounterStatus? status,
    int? disabledAt,
    String? disabledReason,
    bool? isLocked,
  }) {
    return Counter(
      id: id ?? this.id,
      name: name ?? this.name,
      initialCount: initialCount ?? this.initialCount,
      incrementStep: incrementStep ?? this.incrementStep,
      goal: goal ?? this.goal,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      startDate: startDate ?? this.startDate,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      disabledAt: disabledAt ?? this.disabledAt,
      disabledReason: disabledReason ?? this.disabledReason,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'initialCount': initialCount,
    'incrementStep': incrementStep,
    'goal': goal,
    'dailyGoal': dailyGoal,
    'startDate': startDate,
    'createdAt': createdAt,
    'status': status.toDb(),
    'disabledAt': disabledAt,
    'disabledReason': disabledReason,
    'isLocked': isLocked ? 1 : 0,
  };

  factory Counter.fromMap(Map<String, dynamic> map) => Counter(
    id: map['id'] as String,
    name: map['name'] as String,
    initialCount: map['initialCount'] as int? ?? 0,
    incrementStep: map['incrementStep'] as int? ?? 1,
    goal: map['goal'] as int? ?? 0,
    dailyGoal: map['dailyGoal'] as int? ?? 0,
    startDate: map['startDate'] as int? ?? 0,
    createdAt: map['createdAt'] as int? ?? 0,
    status: CounterStatus.fromDb(map['status'] as String? ?? 'ACTIVE'),
    disabledAt: map['disabledAt'] as int?,
    disabledReason: map['disabledReason'] as String?,
    isLocked: (map['isLocked'] as int? ?? 0) == 1,
  );

  /// JSON serialisation — must be compatible with Android Gson export format.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'initialCount': initialCount,
    'incrementStep': incrementStep,
    'goal': goal,
    'dailyGoal': dailyGoal,
    'startDate': startDate,
    'createdAt': createdAt,
    'status': status.toDb(),
    if (disabledAt != null) 'disabledAt': disabledAt,
    if (disabledReason != null) 'disabledReason': disabledReason,
    if (isLocked) 'isLocked': isLocked,
  };

  factory Counter.fromJson(Map<String, dynamic> json) => Counter(
    id: json['id'] as String,
    name: json['name'] as String,
    initialCount: (json['initialCount'] as num?)?.toInt() ?? 0,
    incrementStep: (json['incrementStep'] as num?)?.toInt() ?? 1,
    goal: (json['goal'] as num?)?.toInt() ?? 0,
    dailyGoal: (json['dailyGoal'] as num?)?.toInt() ?? 0,
    startDate: (json['startDate'] as num?)?.toInt() ?? 0,
    createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
    status: CounterStatus.fromDb(json['status'] as String? ?? 'ACTIVE'),
    disabledAt: (json['disabledAt'] as num?)?.toInt(),
    disabledReason: json['disabledReason'] as String?,
    isLocked: json['isLocked'] as bool? ?? false,
  );
}
