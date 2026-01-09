class TrainingHistoryRequest {
  final String userId;
  final String trainingName;
  final TrainingTime time;
  final List<PushData> pushData;
  final String note;

  TrainingHistoryRequest({
    required this.userId,
    required this.trainingName,
    required this.time,
    required this.pushData,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'trainingName': trainingName,
      'time': time.toJson(),
      'pushData': pushData.map((e) => e.toJson()).toList(),
      'note': note,
    };
  }
}

class TrainingTime {
  final String hour;
  final String minite;

  TrainingTime({required this.hour, required this.minite});

  Map<String, dynamic> toJson() {
    return {'hour': hour, 'minite': minite};
  }
}

class PushData {
  final num weight;
  final String repRange;
  final String rir;
  final int set;
  final String exerciseName;

  PushData({
    required this.weight,
    required this.repRange,
    required this.rir,
    required this.set,
    required this.exerciseName,
  });

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'repRange': repRange,
      'rir': rir,
      'set': set,
      'exerciseName': exerciseName,
    };
  }
}
