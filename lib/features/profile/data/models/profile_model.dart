import 'package:fitness_app/domain/entities/profile_entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.athlete,
    required super.coachName,
    required super.timeline,
    required super.show,
    required super.countDown,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      athlete: AthleteModel.fromJson(json['athlete'] ?? {}),
      coachName: json['coachName'] as String? ?? '',
      timeline: TimelineModel.fromJson(json['timeline'] ?? {}),
      show: ShowModel.fromJson(json['show'] ?? {}),
      countDown: json['countDown'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'athlete': (athlete as AthleteModel).toJson(),
      'coachName': coachName,
      'timeline': (timeline as TimelineModel).toJson(),
      'show': (show as ShowModel).toJson(),
      'countDown': countDown,
    };
  }
}

class AthleteModel extends AthleteEntity {
  const AthleteModel({
    required super.id,
    required super.name,
    required super.coachId,
    required super.role,
    required super.email,
    required super.gender,
    required super.category,
    required super.phase,
    required super.weight,
    required super.height,
    required super.image,
    required super.notifiedThisWeek,
    required super.age,
    required super.waterQuantity,
    required super.status,
    required super.trainingDaySteps,
    required super.restDaySteps,
    required super.checkInDay,
    required super.goal,
    required super.verified,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
    required super.lastActive,
  });

  factory AthleteModel.fromJson(Map<String, dynamic> json) {
    return AthleteModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      coachId: json['coachId'] as String? ?? '',
      role: json['role'] as String? ?? '',
      email: json['email'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      category: json['category'] as String? ?? '',
      phase: json['phase'] as String? ?? '',
      weight: json['weight'] as num? ?? 0,
      height: json['height'] as num? ?? 0,
      image: json['image'] as String? ?? '',
      notifiedThisWeek: json['notifiedThisWeek'] as bool? ?? false,
      age: json['age'] as int? ?? 0,
      waterQuantity: json['waterQuantity'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      trainingDaySteps: json['trainingDaySteps'] as int? ?? 0,
      restDaySteps: json['restDaySteps'] as int? ?? 0,
      checkInDay: json['checkInDay'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
      verified: json['verified'] as bool? ?? false,
      isActive: json['isActive'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      lastActive: json['lastActive'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'coachId': coachId,
      'role': role,
      'email': email,
      'gender': gender,
      'category': category,
      'phase': phase,
      'weight': weight,
      'height': height,
      'image': image,
      'notifiedThisWeek': notifiedThisWeek,
      'age': age,
      'waterQuantity': waterQuantity,
      'status': status,
      'trainingDaySteps': trainingDaySteps,
      'restDaySteps': restDaySteps,
      'checkInDay': checkInDay,
      'goal': goal,
      'verified': verified,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastActive': lastActive,
    };
  }
}

class TimelineModel extends TimelineEntity {
  const TimelineModel({
    required super.id,
    required super.nextCheckInDate,
    required super.phase,
  });

  factory TimelineModel.fromJson(Map<String, dynamic> json) {
    return TimelineModel(
      id: json['_id'] as String? ?? '',
      nextCheckInDate: json['nextCheckInDate'] as String? ?? '',
      phase: json['phase'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'nextCheckInDate': nextCheckInDate, 'phase': phase};
  }
}

class ShowModel extends ShowEntity {
  const ShowModel({required super.id, required super.date});

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    return ShowModel(
      id: json['_id'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'date': date};
  }
}
