import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/core/constants/app_icons.dart';
import 'package:fitness_app/core/theme/app_themes/app_theme.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_request_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_response_entity.dart';
import 'package:fitness_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:fitness_app/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

RegisterUseCase stubRegisterUseCase({
  BaseResponse<RegisterResponeEntity>? response,
}) {
  final useCase = MockRegisterUseCase();
  registerFallbackValue(RegisterRequestEntity());
  when(() => useCase(any())).thenAnswer(
    (_) async => response ?? Success(RegisterResponeEntity(message: 'ok')),
  );
  return useCase;
}

Future<void> pumpRegisterWidget(
  WidgetTester tester,
  Widget child, {
  RegisterCubit? cubit,
  Map<String, WidgetBuilder> routes = const {},
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  Widget app = MaterialApp(
    theme: AppTheme.lightTheme,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routes: routes,
    home: child,
  );

  if (cubit != null) {
    app = BlocProvider.value(value: cubit, child: app);
  }

  await tester.pumpWidget(
    ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: app,
    ),
  );
  await tester.pump();
}

Future<void> tapNextStep(WidgetTester tester) async {
  final next = find.widgetWithText(ElevatedButton, 'Next').hitTestable();
  await tester.ensureVisible(next);
  await tester.tap(next);
  await tester.pumpAndSettle();
}

Finder findBackButton() {
  return find.byWidgetPredicate(
    (widget) =>
        widget is SvgPicture &&
        widget.bytesLoader is SvgAssetLoader &&
        (widget.bytesLoader as SvgAssetLoader).assetName == AppIcons.arrowBack,
  );
}
