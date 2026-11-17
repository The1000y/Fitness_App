import 'package:equatable/equatable.dart';

class ChangePasswordParam extends Equatable {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordParam({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}
