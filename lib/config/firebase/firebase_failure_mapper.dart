import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/config/errors/app_failure.dart';

AppFailure mapFirebaseExceptionToAppFailure(
  FirebaseException error,
) {
  switch (error.code) {
    case 'permission-denied':
      return const ForbiddenFailure();

    case 'unauthenticated':
      return const UnauthorizedFailure();

    case 'not-found':
      return const NotFoundFailure();

    case 'deadline-exceeded':
      return const TimeoutFailure();

    case 'cancelled':
      return const CancelFailure();

    case 'invalid-argument':
      return BadRequestFailure(
        serverMessage: error.message,
      );

    case 'already-exists':
    case 'aborted':
      return ConflictFailure(
        serverMessage: error.message,
      );

    case 'resource-exhausted':
      return const TooManyRequestsFailure();

    case 'unavailable':
    case 'internal':
      return const ServerFailure();

    default:
      return const UnknownFailure();
  }
}