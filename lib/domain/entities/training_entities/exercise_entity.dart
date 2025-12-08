import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String id;
  final String title;
  final String category;
  final String equipment;
  final List<String> tags;
  final String description;
  final String imageUrl;

  const ExerciseEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.equipment,
    this.tags = const [],
    this.description = '',
    this.imageUrl = '',
  });

  ExerciseEntity copyWith({String? id, String? title, String? category, String? equipment, List<String>? tags, String? description, String? imageUrl}) => ExerciseEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        category: category ?? this.category,
        equipment: equipment ?? this.equipment,
        tags: tags ?? this.tags,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  @override
  List<Object?> get props => [id, title, category, equipment, tags, description, imageUrl];
}
