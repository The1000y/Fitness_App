import 'package:equatable/equatable.dart';

class ResetPasswordParam extends Equatable {
  final String email;

  final String password;

  const ResetPasswordParam({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
