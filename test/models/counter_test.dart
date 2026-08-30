import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/counter_status.dart';

void main() {
  final base = Counter(
    id: 'test-id',
    name: 'Gayatri',
    goal: 100,
    dailyGoal: 10,
    startDate: 0,
    createdAt: 0,
  );

  group('Goal progress', () {
    test('lifetimeProgress: 50/100 = 0.5', () {
      expect(base.lifetimeProgress(50), 0.5);
    });

    test('lifetimeProgress capped at 1.0', () {
      expect(base.lifetimeProgress(200), 1.0);
    });

    test('lifetimeProgress is 0 when no goal', () {
      final c = base.copyWith(goal: 0);
      expect(c.lifetimeProgress(50), 0.0);
    });

    test('dailyProgress: 5/10 = 0.5', () {
      expect(base.dailyProgress(5), 0.5);
    });

    test('isLifetimeGoalAchieved true at exactly goal', () {
      expect(base.isLifetimeGoalAchieved(100), true);
    });

    test('isLifetimeGoalAchieved false below goal', () {
      expect(base.isLifetimeGoalAchieved(99), false);
    });
  });

  group('CounterStatus round-trip', () {
    test('ACTIVE serialises and deserialises', () {
      expect(CounterStatus.fromDb('ACTIVE'), CounterStatus.active);
      expect(CounterStatus.active.toDb(), 'ACTIVE');
    });

    test('DISABLED_SUCCESS round-trip', () {
      expect(
        CounterStatus.fromDb('DISABLED_SUCCESS'),
        CounterStatus.disabledSuccess,
      );
      expect(CounterStatus.disabledSuccess.toDb(), 'DISABLED_SUCCESS');
    });

    test('Unknown value falls back to active', () {
      expect(CounterStatus.fromDb('UNKNOWN'), CounterStatus.active);
    });
  });

  group('JSON round-trip (Android Gson compatibility)', () {
    test('toJson / fromJson round-trip', () {
      final json = base.toJson();
      final restored = Counter.fromJson(json);
      expect(restored.id, base.id);
      expect(restored.name, base.name);
      expect(restored.goal, base.goal);
      expect(restored.status, CounterStatus.active);
    });

    test('fromJson tolerates missing optional fields', () {
      final minimal = <String, dynamic>{
        'id': 'x',
        'name': 'Test',
        'startDate': 0,
        'createdAt': 0,
      };
      final c = Counter.fromJson(minimal);
      expect(c.incrementStep, 1);
      expect(c.goal, 0);
      expect(c.isLocked, false);
    });
  });

  group('Counter locking', () {
    test('defaults to unlocked (isLocked = false)', () {
      expect(base.isLocked, false);
    });

    test('copyWith toggles isLocked', () {
      final locked = base.copyWith(isLocked: true);
      expect(locked.isLocked, true);
      final unlocked = locked.copyWith(isLocked: false);
      expect(unlocked.isLocked, false);
    });

    test('toMap and fromMap preserve isLocked', () {
      final locked = base.copyWith(isLocked: true);
      final map = locked.toMap();
      expect(map['isLocked'], 1);
      final restored = Counter.fromMap(map);
      expect(restored.isLocked, true);

      final unmap = base.toMap();
      expect(unmap['isLocked'], 0);
      expect(Counter.fromMap(unmap).isLocked, false);
    });

    test('toJson and fromJson preserve isLocked', () {
      final locked = base.copyWith(isLocked: true);
      final json = locked.toJson();
      expect(json['isLocked'], true);
      final restored = Counter.fromJson(json);
      expect(restored.isLocked, true);
    });
  });
}
