
import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/errors/app_failure.dart';


class BaseState<T> extends Equatable {
  final AppFailure? errorMessage;
  final bool isLoading;
  final T? data;

  static const _clearValue = Object();

  const BaseState({this.isLoading = false, this.errorMessage, this.data});


  BaseState<T> copyWith({
    Object? errorMessage =_clearValue ,
    bool? isLoading,
    Object? data = _clearValue,
  }) {
    return BaseState<T>(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage== _clearValue ? this.errorMessage : errorMessage as AppFailure?,
      data : data == _clearValue ? this.data : data as T?,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        data,
      ];
}
