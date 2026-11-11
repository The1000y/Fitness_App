
import 'package:equatable/equatable.dart';

class AppAuthState extends Equatable {
  final String? userId;

  const AppAuthState({this.userId});

  AppAuthState copyWith({String? userId}) {
    return AppAuthState(
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [userId];
}
