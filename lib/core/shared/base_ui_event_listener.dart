import 'dart:async';
import 'package:fitness_app/config/localization/app_failure_message_mapper.dart';
import 'package:fitness_app/config/localization/success_message_enum_mapper.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../config/base/base_cubit.dart';
import '../../../config/base/base_ui_event.dart';
import '../theme/app_colors/app_colors.dart';

class BaseUiEventListener<C extends BaseCubit<S, E>, S, E extends BaseUiEvent>
    extends StatefulWidget {
  const BaseUiEventListener({
    super.key,
    this.cubit,
    this.onCustomEvent,
    this.navigatorKey,
    required this.child,
  });

  final C? cubit;
  final void Function(BuildContext context, E event)? onCustomEvent;
  final Widget child;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  State<BaseUiEventListener<C, S, E>> createState() =>
      _BaseUiEventListenerState<C, S, E>();
}

class _BaseUiEventListenerState<
  C extends BaseCubit<S, E>,
  S,
  E extends BaseUiEvent
>
    extends State<BaseUiEventListener<C, S, E>> {
  StreamSubscription<E>? _subscription;

  NavigatorState get _navigator =>
      widget.navigatorKey?.currentState ?? Navigator.of(context);

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant BaseUiEventListener<C, S, E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cubit != widget.cubit) {
      _unsubscribe();
      _subscribe();
    }
  }

  void _subscribe() {
    final targetCubit = widget.cubit ?? context.read<C>();
    _subscription = targetCubit.uiEventStream.listen((event) {
      if (mounted) {
        _handleEvent(context, event);
      }
    });
  }

  void _handleEvent(BuildContext context, E event) {
    if (event is CommonUiEvent) {
      _handleCommonEvent(context, event);
    } else {
      widget.onCustomEvent?.call(context, event);
    }
  }

  void _handleCommonEvent(BuildContext context, CommonUiEvent event) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    switch (event) {
      case ShowSuccessMessage():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              successMessageMapper(event.message, local) ?? '',
              style:
                  theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontSize: 14.sp,
                  ) ??
                  TextStyle(color: AppColors.white, fontSize: 14.sp),
            ),
            backgroundColor: Colors.green.shade700,
          ),
        );
      case ShowFailureMessage():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              appFailureMessageMapper(event.failure, local),
              style:
                  theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontSize: 14.sp,
                  ) ??
                  TextStyle(color: AppColors.white, fontSize: 14.sp),
            ),
            backgroundColor: AppColors.glow,
          ),
        );
      case NavigateTo():
        _navigator.pushNamed(event.routeName, arguments: event.arguments);
      case NavigateReplaceTo():
        _navigator.pushReplacementNamed(
          event.routeName,
          arguments: event.arguments,
        );
      case PopRoute():
        _navigator.pop(event.result);
      case NavigateAndRemoveUntil():
        _navigator.pushNamedAndRemoveUntil(
          event.routeName,
          (route) => false,
          arguments: event.arguments,
        );
      // Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      //   event.routeName,
      //   (route) => false,
      //   arguments: event.arguments,
      // );
    }
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
