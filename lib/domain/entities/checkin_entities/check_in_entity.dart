import 'package:equatable/equatable.dart';

class CheckInEntity extends Equatable {
  final int step;
  final String answer1;
  final String answer2;
  final CheckInWellBeing wellBeing;
  final CheckInNutrition nutrition;
  final CheckInTraining training;
  final CheckInUploads uploads;
  final String dailyNotes;

  const CheckInEntity({
    this.step = 0,
    this.answer1 = '',
    this.answer2 = '',
    this.wellBeing = const CheckInWellBeing(),
    this.nutrition = const CheckInNutrition(),
    this.training = const CheckInTraining(),
    this.uploads = const CheckInUploads(),
    this.dailyNotes = '',
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
    );
  }

  @override
  List<Object?> get props => [step, answer1, answer2, wellBeing, nutrition, training, uploads, dailyNotes];
}

class CheckInWellBeing extends Equatable {
  final double energy;
  final double stress;
  final double mood;
  final double sleep;

  const CheckInWellBeing({this.energy = 6, this.stress = 6, this.mood = 6, this.sleep = 6});

  CheckInWellBeing copyWith({double? energy, double? stress, double? mood, double? sleep}) =>
      CheckInWellBeing(energy: energy ?? this.energy, stress: stress ?? this.stress, mood: mood ?? this.mood, sleep: sleep ?? this.sleep);

  @override
  List<Object?> get props => [energy, stress, mood, sleep];
}

class CheckInNutrition extends Equatable {
  final double dietLevel;
  final double digestion;
  final String challenge;

  const CheckInNutrition({this.dietLevel = 6, this.digestion = 6, this.challenge = ''});

  CheckInNutrition copyWith({double? dietLevel, double? digestion, String? challenge}) =>
      CheckInNutrition(dietLevel: dietLevel ?? this.dietLevel, digestion: digestion ?? this.digestion, challenge: challenge ?? this.challenge);

  @override
  List<Object?> get props => [dietLevel, digestion, challenge];
}

class CheckInTraining extends Equatable {
  final double feelStrength;
  final double pumps;
  final bool trainingCompleted;
  final bool cardioCompleted;
  final String feedback;

  const CheckInTraining({this.feelStrength = 6, this.pumps = 6, this.trainingCompleted = true, this.cardioCompleted = true, this.feedback = ''});

  CheckInTraining copyWith({double? feelStrength, double? pumps, bool? trainingCompleted, bool? cardioCompleted, String? feedback}) => CheckInTraining(
        feelStrength: feelStrength ?? this.feelStrength,
        pumps: pumps ?? this.pumps,
        trainingCompleted: trainingCompleted ?? this.trainingCompleted,
        cardioCompleted: cardioCompleted ?? this.cardioCompleted,
        feedback: feedback ?? this.feedback,
      );

  @override
  List<Object?> get props => [feelStrength, pumps, trainingCompleted, cardioCompleted, feedback];
}

class CheckInUploads extends Equatable {
  final bool picturesUploaded;
  final bool videoUploaded;

  const CheckInUploads({this.picturesUploaded = true, this.videoUploaded = true});

  CheckInUploads copyWith({bool? picturesUploaded, bool? videoUploaded}) => CheckInUploads(
        picturesUploaded: picturesUploaded ?? this.picturesUploaded,
        videoUploaded: videoUploaded ?? this.videoUploaded,
      );

  @override
  List<Object?> get props => [picturesUploaded, videoUploaded];
}
