import 'package:equatable/equatable.dart';

class VitalEntity extends Equatable {
  final String dateLabel;
  final String weightText;
  final String waterText;
  final String bodyTempText;
  final String activityTimeText;

  const VitalEntity({
    required this.dateLabel,
    required this.weightText,
    required this.waterText,
    required this.bodyTempText,
    required this.activityTimeText,
  });

  VitalEntity copyWith({
    String? dateLabel,
    String? weightText,
    String? waterText,
    String? bodyTempText,
    String? activityTimeText,
  }) => VitalEntity(
        dateLabel: dateLabel ?? this.dateLabel,
        weightText: weightText ?? this.weightText,
        waterText: waterText ?? this.waterText,
        bodyTempText: bodyTempText ?? this.bodyTempText,
        activityTimeText: activityTimeText ?? this.activityTimeText,
      );

  @override
  List<Object?> get props => [dateLabel, weightText, waterText, bodyTempText, activityTimeText];
}

