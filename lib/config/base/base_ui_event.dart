

import 'package:fitness_app/config/errors/app_failure.dart';

sealed class BaseUiEvent {
  const BaseUiEvent();
}

final class ShowSuccessMessage extends BaseUiEvent {
  final String message;
  const ShowSuccessMessage(this.message);
}

final class ShowFailureMessage extends BaseUiEvent {
  final AppFailure failure;
  const ShowFailureMessage(this.failure);
}

class NavigateTo extends BaseUiEvent {
  final String routeName;
  final Object? arguments;

  const NavigateTo(this.routeName, {this.arguments});
}

class NavigateRepalceTo extends BaseUiEvent {
  final String routeName;
  final Object? arguments;
  const NavigateRepalceTo(this.routeName, {this.arguments});
}

class PopRoute extends BaseUiEvent {
  final Object? result;
  const PopRoute([this.result]);
}
