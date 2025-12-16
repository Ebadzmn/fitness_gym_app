import 'package:equatable/equatable.dart';
import 'dart:convert';

class CheckInEntity extends Equatable {
  final int step;
  final String answer1;
  final String answer2;
  final CheckInWellBeing wellBeing;
  final CheckInNutrition nutrition;
  final CheckInTraining training;
  final CheckInUploads uploads;
  final String dailyNotes;
  final String? weekId;

  const CheckInEntity({
    this.step = 0,
    this.answer1 = '',
    this.answer2 = '',
    this.wellBeing = const CheckInWellBeing(),
    this.nutrition = const CheckInNutrition(),
    this.training = const CheckInTraining(),
    this.uploads = const CheckInUploads(),
    this.dailyNotes = '',
    this.weekId,
  });

  CheckInEntity copyWith({
    int? step,
    String? answer1,
    String? answer2,
    CheckInWellBeing? wellBeing,
    CheckInNutrition? nutrition,
    CheckInTraining? training,
    CheckInUploads? uploads,
    String? dailyNotes,
    String? weekId,
  }) {
    return CheckInEntity(
      step: step ?? this.step,
      answer1: answer1 ?? this.answer1,
      answer2: answer2 ?? this.answer2,
      wellBeing: wellBeing ?? this.wellBeing,
      nutrition: nutrition ?? this.nutrition,
      training: training ?? this.training,
      uploads: uploads ?? this.uploads,
      dailyNotes: dailyNotes ?? this.dailyNotes,
      weekId: weekId ?? this.weekId,
    );
  }

  Map<String, dynamic> toMap() => {
    'step': step,
    'answer1': answer1,
    'answer2': answer2,
    'wellBeing': wellBeing.toMap(),
    'nutrition': nutrition.toMap(),
    'training': training.toMap(),
    'uploads': uploads.toMap(),
    'dailyNotes': dailyNotes,
    'weekId': weekId,
  };
  factory CheckInEntity.fromMap(Map<String, dynamic> map) => CheckInEntity(
    step: map['step'] ?? 0,
    answer1: map['answer1'] ?? '',
    answer2: map['answer2'] ?? '',
    wellBeing: CheckInWellBeing.fromMap(
      Map<String, dynamic>.from(map['wellBeing'] ?? {}),
    ),
    nutrition: CheckInNutrition.fromMap(
      Map<String, dynamic>.from(map['nutrition'] ?? {}),
    ),
    training: CheckInTraining.fromMap(
      Map<String, dynamic>.from(map['training'] ?? {}),
    ),
    uploads: CheckInUploads.fromMap(
      Map<String, dynamic>.from(map['uploads'] ?? {}),
    ),
    dailyNotes: map['dailyNotes'] ?? '',
    weekId: map['weekId'],
  );
  String toJson() => jsonEncode(toMap());
  factory CheckInEntity.fromJson(String source) =>
      CheckInEntity.fromMap(jsonDecode(source));

  @override
  List<Object?> get props => [
    step,
    answer1,
    answer2,
    wellBeing,
    nutrition,
    training,
    uploads,
    dailyNotes,
    weekId,
  ];
}

class CheckInWellBeing extends Equatable {
  final double energy;
  final double stress;
  final double mood;
  final double sleep;

  const CheckInWellBeing({
    this.energy = 6,
    this.stress = 6,
    this.mood = 6,
    this.sleep = 6,
  });

  CheckInWellBeing copyWith({
    double? energy,
    double? stress,
    double? mood,
    double? sleep,
  }) => CheckInWellBeing(
    energy: energy ?? this.energy,
    stress: stress ?? this.stress,
    mood: mood ?? this.mood,
    sleep: sleep ?? this.sleep,
  );

  Map<String, dynamic> toMap() => {
    'energy': energy,
    'stress': stress,
    'mood': mood,
    'sleep': sleep,
  };
  factory CheckInWellBeing.fromMap(Map<String, dynamic> map) =>
      CheckInWellBeing(
        energy: (map['energy'] ?? 6).toDouble(),
        stress: (map['stress'] ?? 6).toDouble(),
        mood: (map['mood'] ?? 6).toDouble(),
        sleep: (map['sleep'] ?? 6).toDouble(),
      );

  @override
  List<Object?> get props => [energy, stress, mood, sleep];
}

class CheckInNutrition extends Equatable {
  final double dietLevel;
  final double digestion;
  final String challenge;

  const CheckInNutrition({
    this.dietLevel = 6,
    this.digestion = 6,
    this.challenge = '',
  });

  CheckInNutrition copyWith({
    double? dietLevel,
    double? digestion,
    String? challenge,
  }) => CheckInNutrition(
    dietLevel: dietLevel ?? this.dietLevel,
    digestion: digestion ?? this.digestion,
    challenge: challenge ?? this.challenge,
  );

  Map<String, dynamic> toMap() => {
    'dietLevel': dietLevel,
    'digestion': digestion,
    'challenge': challenge,
  };
  factory CheckInNutrition.fromMap(Map<String, dynamic> map) =>
      CheckInNutrition(
        dietLevel: (map['dietLevel'] ?? 6).toDouble(),
        digestion: (map['digestion'] ?? 6).toDouble(),
        challenge: map['challenge'] ?? '',
      );

  @override
  List<Object?> get props => [dietLevel, digestion, challenge];
}

class CheckInTraining extends Equatable {
  final double feelStrength;
  final double pumps;
  final bool trainingCompleted;
  final bool cardioCompleted;
  final String feedback;
  final String cardioType;
  final String cardioDuration;

  const CheckInTraining({
    this.feelStrength = 6,
    this.pumps = 6,
    this.trainingCompleted = true,
    this.cardioCompleted = true,
    this.feedback = '',
    this.cardioType = '',
    this.cardioDuration = '',
  });

  CheckInTraining copyWith({
    double? feelStrength,
    double? pumps,
    bool? trainingCompleted,
    bool? cardioCompleted,
    String? feedback,
    String? cardioType,
    String? cardioDuration,
  }) => CheckInTraining(
    feelStrength: feelStrength ?? this.feelStrength,
    pumps: pumps ?? this.pumps,
    trainingCompleted: trainingCompleted ?? this.trainingCompleted,
    cardioCompleted: cardioCompleted ?? this.cardioCompleted,
    feedback: feedback ?? this.feedback,
    cardioType: cardioType ?? this.cardioType,
    cardioDuration: cardioDuration ?? this.cardioDuration,
  );

  Map<String, dynamic> toMap() => {
    'feelStrength': feelStrength,
    'pumps': pumps,
    'trainingCompleted': trainingCompleted,
    'cardioCompleted': cardioCompleted,
    'feedback': feedback,
    'cardioType': cardioType,
    'cardioDuration': cardioDuration,
  };
  factory CheckInTraining.fromMap(Map<String, dynamic> map) => CheckInTraining(
    feelStrength: (map['feelStrength'] ?? 6).toDouble(),
    pumps: (map['pumps'] ?? 6).toDouble(),
    trainingCompleted: map['trainingCompleted'] ?? true,
    cardioCompleted: map['cardioCompleted'] ?? true,
    feedback: map['feedback'] ?? '',
    cardioType: map['cardioType'] ?? '',
    cardioDuration: map['cardioDuration'] ?? '',
  );

  @override
  List<Object?> get props => [
    feelStrength,
    pumps,
    trainingCompleted,
    cardioCompleted,
    feedback,
    cardioType,
    cardioDuration,
  ];
}

class CheckInUploads extends Equatable {
  final bool picturesUploaded;
  final bool videoUploaded;

  const CheckInUploads({
    this.picturesUploaded = true,
    this.videoUploaded = true,
  });

  CheckInUploads copyWith({bool? picturesUploaded, bool? videoUploaded}) =>
      CheckInUploads(
        picturesUploaded: picturesUploaded ?? this.picturesUploaded,
        videoUploaded: videoUploaded ?? this.videoUploaded,
      );

  Map<String, dynamic> toMap() => {
    'picturesUploaded': picturesUploaded,
    'videoUploaded': videoUploaded,
  };
  factory CheckInUploads.fromMap(Map<String, dynamic> map) => CheckInUploads(
    picturesUploaded: map['picturesUploaded'] ?? true,
    videoUploaded: map['videoUploaded'] ?? true,
  );

  @override
  List<Object?> get props => [picturesUploaded, videoUploaded];
}
