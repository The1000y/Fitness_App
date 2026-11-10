
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:fitness_app/config/base/base_response.dart';
import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/firebase/firebase_failure_mapper.dart';

Future<BaseResponse<T>> executeFirestoreCall<T>(
  Future<T> Function() request,
) async {
  try {
    return Success<T>(await request());
  } on FirebaseException catch (e) {
    return Error<T>(mapFirebaseExceptionToAppFailure(e));
  } catch (e, st) {
    debugPrint('FIRESTORE ERROR => $e\n$st');
    return Error<T>(const UnknownFailure());
  }
}
