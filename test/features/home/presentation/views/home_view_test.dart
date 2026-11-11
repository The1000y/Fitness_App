import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/features/home/presentation/manager/home_cubit.dart';
import 'package:fitness_app/features/home/presentation/manager/home_state.dart';
import 'package:fitness_app/features/home/presentation/views/home_view.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:fitness_app/features/profile/presentation/manager/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/pump_app.dart';

class MockHomeCubit extends Mock implements HomeCubit {}

class MockProfileCubit extends Mock implements ProfileCubit {}

void main() {
  late MockHomeCubit homeCubit;
  late MockProfileCubit profileCubit;

  setUp(() async {
    await getIt.reset();
    homeCubit = MockHomeCubit();
    profileCubit = MockProfileCubit();

    when(() => homeCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => homeCubit.state).thenReturn(const HomeState());
    when(() => homeCubit.close()).thenAnswer((_) async {});

    when(() => profileCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => profileCubit.state).thenReturn(const ProfileState());
    when(() => profileCubit.close()).thenAnswer((_) async {});

    getIt.registerFactory<HomeCubit>(() => homeCubit);
    getIt.registerFactory<ProfileCubit>(() => profileCubit);
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('HomeView renders successfully', (tester) async {
    await tester.pumpApp(const HomeView());
    expect(find.byType(HomeView), findsOneWidget);
  });
}
