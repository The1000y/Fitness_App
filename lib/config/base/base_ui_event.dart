import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/localization/success_message_enum_mapper.dart';

abstract class BaseUiEvent {
  const BaseUiEvent();
}

sealed class CommonUiEvent extends BaseUiEvent {
  const CommonUiEvent();
}

final class ShowSuccessMessage extends CommonUiEvent {
  final AppSuccessMessage message;
  const ShowSuccessMessage(this.message);
}

final class ShowFailureMessage extends CommonUiEvent {
  final AppFailure failure;
  const ShowFailureMessage(this.failure);
}

final class NavigateTo extends CommonUiEvent {
  final String routeName;
  final Object? arguments;

  const NavigateTo(this.routeName, {this.arguments});
}

final class NavigateReplaceTo extends CommonUiEvent {
  final String routeName;
  final Object? arguments;
  const NavigateReplaceTo(this.routeName, {this.arguments});
}

final class PopRoute extends CommonUiEvent {
  final Object? result;
  const PopRoute([this.result]);
}

final class NavigateAndRemoveUntil extends CommonUiEvent {
  final String routeName;
  final Object? arguments;
  const NavigateAndRemoveUntil(this.routeName, {this.arguments});
}
