import 'package:equatable/equatable.dart';

class OnboardingEntity extends Equatable {
  final String id;
  final String image;
  final String title;
  final String description;

  const OnboardingEntity({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [id, image, title, description];
}
