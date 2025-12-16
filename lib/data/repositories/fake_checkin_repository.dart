import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/checkin_entities/check_in_entity.dart';

class FakeCheckInRepository {
  static const String _entriesKey = 'weekly_checkin_entries';

  Future<CheckInEntity> loadInitial() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final prefs = await SharedPreferences.getInstance();
    final nowWeekId = _computeWeekId(DateTime.now());
    final list = prefs.getStringList(_entriesKey) ?? const <String>[];
    for (final jsonStr in list.reversed) {
      final entity = CheckInEntity.fromJson(jsonStr);
      if (entity.weekId == nowWeekId) {
        return entity;
      }
    }
    return const CheckInEntity();
  }

  Future<void> save(CheckInEntity data) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final prefs = await SharedPreferences.getInstance();
    final weekId = _computeWeekId(DateTime.now());
    final list = prefs.getStringList(_entriesKey) ?? <String>[];
    final hasDuplicate = list.any((s) {
      try {
        final m = CheckInEntity.fromJson(s);
        return m.weekId == weekId;
      } catch (_) {
        return false;
      }
    });
    if (hasDuplicate) {
      throw StateError('Already checked in for this week');
    }
    final toSave = data.copyWith(weekId: weekId).toJson();
    list.add(toSave);
    await prefs.setStringList(_entriesKey, list);
  }

  Future<List<CheckInEntity>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_entriesKey) ?? const <String>[];
    final items = <CheckInEntity>[];
    for (final s in list) {
      try {
        items.add(CheckInEntity.fromJson(s));
      } catch (_) {}
    }

    // Seed some dummy history if nothing saved yet, so Old Check-In is testable
    if (items.isEmpty) {
      final now = DateTime.now();
      for (int i = 0; i < 3; i++) {
        final weekDate = now.subtract(Duration(days: 7 * i));
        final weekId = _computeWeekId(weekDate);
        items.add(
          CheckInEntity(
            weekId: weekId,
            wellBeing: CheckInWellBeing(
              energy: 6 + (i.toDouble()),
              stress: 4 + (i.toDouble()),
              mood: 5 + (i.toDouble()),
              sleep: 6,
            ),
            nutrition: CheckInNutrition(
              dietLevel: 6 + (i.toDouble()),
              digestion: 5 + (i.toDouble()),
              challenge: 'Sample challenge week ${i + 1}',
            ),
            training: CheckInTraining(
              feelStrength: 6 + i.toDouble(),
              pumps: 6,
              trainingCompleted: true,
              cardioCompleted: i % 2 == 0,
              feedback: 'Sample feedback week ${i + 1}',
              cardioType: i % 2 == 0 ? 'Walking' : 'Cycling',
              cardioDuration: '${20 + i * 5} min',
            ),
            uploads: const CheckInUploads(
              picturesUploaded: true,
              videoUploaded: false,
            ),
            dailyNotes: 'Sample notes for week starting $weekId',
          ),
        );
      }
    }

    items.sort((a, b) {
      final aw = a.weekId ?? '';
      final bw = b.weekId ?? '';
      return bw.compareTo(aw);
    });
    return items;
  }

  String _computeWeekId(DateTime dt) {
    final monday = dt.subtract(Duration(days: dt.weekday - 1));
    final y = monday.year.toString().padLeft(4, '0');
    final m = monday.month.toString().padLeft(2, '0');
    final d = monday.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
