import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/checkin_entities/check_in_entity.dart';
import '../../domain/entities/checkin_entities/check_in_date_entity.dart';
import '../../domain/entities/checkin_entities/old_check_in_entity.dart';
import '../../core/network/api_client.dart';
import '../../core/apiUrls/api_urls.dart';

class FakeCheckInRepository {
  final ApiClient apiClient;
  static const String _entriesKey = 'weekly_checkin_entries';

  FakeCheckInRepository({required this.apiClient});

  Future<CheckInDateEntity> getCheckInDate() async {
    final response = await apiClient.get(ApiUrls.checkInDate);
    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'];
      return CheckInDateEntity.fromMap(data);
    }
    // Fallback or throw error
    throw Exception('Failed to load check-in date');
  }

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
    final formData = Map<String, dynamic>();

    formData['currentWeight'] = data.currentWeight;
    formData['averageWeight'] = data.averageWeight;

    // questionAndAnswer
    formData['questionAndAnswer[0][question]'] =
        'Q1 . What are you proud of? *';
    formData['questionAndAnswer[0][answer]'] = data.answer1;
    formData['questionAndAnswer[1][question]'] =
        'Q2 . Calories per default quantity *';
    formData['questionAndAnswer[1][answer]'] = data.answer2;

    // wellBeing
    formData['wellBeing[energyLevel]'] = data.wellBeing.energy.round();
    formData['wellBeing[stressLevel]'] = data.wellBeing.stress.round();
    formData['wellBeing[moodLevel]'] = data.wellBeing.mood.round();
    formData['wellBeing[sleepQuality]'] = data.wellBeing.sleep.round();

    // nutrition
    formData['nutrition[dietLevel]'] = data.nutrition.dietLevel.round();
    formData['nutrition[digestionLevel]'] = data.nutrition.digestion.round();
    formData['nutrition[challengeDiet]'] = data.nutrition.challenge;

    // training
    formData['training[feelStrength]'] = data.training.feelStrength.round();
    formData['training[pumps]'] = data.training.pumps.round();
    formData['training[cardioCompleted]'] = data.training.cardioCompleted;
    formData['training[trainingCompleted]'] = data.training.trainingCompleted;
    formData['trainingFeedback'] = data.training.feedback;

    formData['dailyNote'] = data.dailyNotes;

    // Files
    if (data.uploads.videoPath != null && data.uploads.videoPath!.isNotEmpty) {
      formData['video'] = await apiClient.createMultipartFile(
        data.uploads.videoPath!,
      );
    }

    if (data.uploads.picturePaths.isNotEmpty) {
      final List<dynamic> images = [];
      for (final path in data.uploads.picturePaths) {
        images.add(await apiClient.createMultipartFile(path));
      }
      formData['image'] = images;
    }

    final response = await apiClient.post(
      ApiUrls.checkInPost,
      data: FormData.fromMap(formData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Successfully saved to server.
      // We could also save locally if needed for history, but user asked for post.
      final prefs = await SharedPreferences.getInstance();
      final weekId = _computeWeekId(DateTime.now());
      final list = prefs.getStringList(_entriesKey) ?? <String>[];
      final toSave = data.copyWith(weekId: weekId).toJson();
      list.add(toSave);
      await prefs.setStringList(_entriesKey, list);
    } else {
      throw Exception(
        'Failed to submit check-in: ${response.data['message'] ?? 'Unknown error'}',
      );
    }
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

  /// Fetch old check-in data from API with pagination.
  /// Returns null if no data found for the given skip value.
  Future<OldCheckInEntity?> getOldCheckIn(int skip) async {
    try {
      final response = await apiClient.get(
        ApiUrls.oldCheckInData,
        queryParameters: {'skip': skip},
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        if (data != null) {
          return OldCheckInEntity.fromMap(Map<String, dynamic>.from(data));
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
