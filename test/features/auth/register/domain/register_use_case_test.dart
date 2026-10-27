import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_request_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/register_entity/register_response_entity.dart';
import 'package:fitness_app/features/auth/domain/repo/auth_repo.dart';
import 'package:fitness_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo repo;
  late RegisterUseCase useCase;

  setUpAll(() {
    registerFallbackValue(RegisterRequestEntity());
  });

  setUp(() {
    repo = MockAuthRepo();
    useCase = RegisterUseCase(repo: repo);
  });

  test('returns the success response from the repository', () async {
    final request = RegisterRequestEntity(
      firstName: 'Ahmed',
      email: 'ahmed@example.com',
    );
    final response = RegisterResponeEntity(
      message: 'Account created',
      token: 'token',
    );

    when(
      () => repo.register(request),
    ).thenAnswer((_) async => Success(response));

    final result = await useCase(request);

    expect(result, isA<Success<RegisterResponeEntity>>());
    expect((result as Success<RegisterResponeEntity>).data, same(response));
    verify(() => repo.register(request)).called(1);
  });

  test('returns the failure from the repository', () async {
    final request = RegisterRequestEntity(email: 'ahmed@example.com');
    const failure = ServerFailure(statusCode: 500);

    when(
      () => repo.register(request),
    ).thenAnswer((_) async => const Error<RegisterResponeEntity>(failure));

    final result = await useCase(request);

    expect(result, isA<Error<RegisterResponeEntity>>());
    expect((result as Error<RegisterResponeEntity>).failure, same(failure));
    verify(() => repo.register(request)).called(1);
  });

  test('passes the same request instance to the repository', () async {
    final request = RegisterRequestEntity(firstName: 'Ahmed');
    final response = RegisterResponeEntity(message: 'ok');

    when(() => repo.register(any())).thenAnswer((_) async => Success(response));

    await useCase(request);

    final captured =
        verify(() => repo.register(captureAny())).captured.single
            as RegisterRequestEntity;

    expect(captured, same(request));
  });
}
