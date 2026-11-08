import 'package:fitness_app/core/constants/app_test_keys.dart';
import 'package:fitness_app/core/shared/confirmation_dialog.dart';
import 'package:fitness_app/features/main/presentation/views/widgets/custom_floating_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../l10n/app_localizations.dart';

class MainLayoutView extends StatefulWidget {
  final List<Widget> tabs;
  const MainLayoutView({super.key, required this.tabs});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  int _currentTap = 0;

  Future<void> _handleBackPress() async {
    if (_currentTap != 0) {
      setState(() => _currentTap = 0);
    } else {
      if (!context.mounted) return;
      await _showCloseAppDialog(context);
    }
  }

  Future<void> _showCloseAppDialog(BuildContext context) async {
    if (Theme.of(context).platform != TargetPlatform.android) return;
    final l10n = AppLocalizations.of(context)!;

    final shouldClose = await showConfirmationDialog(
      context,
      message: l10n.closeAppConfirm,
      dialogKey: const Key(AppTestKeys.closeAppDialog),
      noButtonKey: const Key(AppTestKeys.closeAppDialogNoButton),
      yesButtonKey: const Key(AppTestKeys.closeAppDialogYesButton),
    );

    if (shouldClose) {
      await SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPress();
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(index: _currentTap, children: widget.tabs),
        bottomNavigationBar: CustomFloatingNavigationBar(
          key: const Key(AppTestKeys.mainLayoutBottomNav),
          currentIndex: _currentTap,
          onTap: (index) {
            setState(() => _currentTap = index);
          },
        ),
      ),
    );
  }
}
