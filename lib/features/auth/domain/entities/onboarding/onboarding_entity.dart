import 'package:equatable/equatable.dart';

class OnboardingEntity extends Equatable {
  final String image;
  final String title;
  final String description;

  const OnboardingEntity({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [image, title, description];
}
