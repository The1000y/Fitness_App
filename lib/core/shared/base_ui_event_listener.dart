import 'dart:async';
import 'package:fitness_app/config/localization/app_failure_message_mapper.dart';
import 'package:fitness_app/config/localization/success_message_enum_mapper.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/base/base_cubit.dart';
import '../../../config/base/base_ui_event.dart';

class BaseUiEventListener<C extends BaseCubit<S, E>, S, E extends BaseUiEvent>
    extends StatefulWidget {
  const BaseUiEventListener({
    super.key,
    this.cubit,
    this.onCustomEvent,
    required this.child,
  });

  final C? cubit;
  final void Function(BuildContext context, E event)? onCustomEvent;
  final Widget child;

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

    switch (event) {
      case ShowSuccessMessage():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessageMapper(event.message, local) ?? ''),
            backgroundColor: Colors.green,
          ),
        );
      case ShowFailureMessage():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(appFailureMessageMapper(event.failure, local)),
            backgroundColor: Colors.red,
          ),
        );
      case NavigateTo():
        Navigator.of(context)
            .pushNamed(event.routeName, arguments: event.arguments);
      case NavigateReplaceTo():
        Navigator.of(context)
            .pushReplacementNamed(event.routeName, arguments: event.arguments);
      case PopRoute():
        Navigator.of(context).pop(event.result);
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