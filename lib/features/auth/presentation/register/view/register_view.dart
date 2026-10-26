
import 'package:fitness_app/config/base/base_ui_event.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/constants/app_images.dart';
import 'package:fitness_app/core/shared/base_ui_event_listener.dart';
import 'package:fitness_app/core/shared/custom_background_image.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_event.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_state.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_ui_event.dart';
import 'package:fitness_app/features/auth/presentation/register/view/register_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterCubit>(),
      child: const _RegisterFlow(),
    );
  }
}

class _RegisterFlow extends StatefulWidget {
  const _RegisterFlow();

  @override
  State<_RegisterFlow> createState() => _RegisterFlowState();
}

class _RegisterFlowState extends State<_RegisterFlow> {
  final _pageController = PageController();
  int _page = 0; // 0 = الفورم، 1..6 = الخطوات

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    setState(() => _page = page);
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onUiEvent(BuildContext context, BaseUiEvent event) {
    if (event is! RegisterUiEvent) return;

    switch (event) {
      case AcceptFirstUiEvent():
        _goTo(1);
      case StepChangedUiEvent(:final step):
        _goTo(step + 1);
      case BackToCredentialsUiEvent():
        _goTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _page == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.read<RegisterCubit>().doEvent(const PreviousStepEvent());
        }
      },
      child: BaseUiEventListener<RegisterCubit, RegisterState, BaseUiEvent>(
        onCustomEvent: _onUiEvent,
        child: CustomBackgroundImage(
          backgroundImage: AppImages.authBackground,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const RegisterFormPage(),
                  /*switch page */
                  for (var i = 1; i <= 6; i++)
                    Center(
                      child: Text(
                        'Step $i',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}