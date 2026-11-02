import 'package:fitness_app/config/errors/app_failure.dart';
import 'package:fitness_app/config/localization/app_failure_message_mapper.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('appFailureMessageMapper', () {
    test('maps all AppFailure variants correctly to localized strings', () {
      expect(appFailureMessageMapper(const InternetConnectionFailure(), l10n), l10n.failureInternetConnection);
      expect(appFailureMessageMapper(const TimeoutFailure(), l10n), l10n.failureTimeout);
      expect(appFailureMessageMapper(const CancelFailure(), l10n), l10n.failureCancel);
      expect(appFailureMessageMapper(const BadCertificateFailure(), l10n), l10n.failureBadCertificate);
      expect(appFailureMessageMapper(const UnauthorizedFailure(), l10n), l10n.failureUnauthorized);
      expect(appFailureMessageMapper(const ForbiddenFailure(), l10n), l10n.failureForbidden);
      expect(appFailureMessageMapper(const NotFoundFailure(), l10n), l10n.failureNotFound);
      expect(appFailureMessageMapper(const MethodNotAllowedFailure(), l10n), l10n.failureMethodNotAllowed);
      expect(appFailureMessageMapper(const TooManyRequestsFailure(), l10n), l10n.failureTooManyRequests);
      expect(appFailureMessageMapper(const ServerFailure(statusCode: 500), l10n), l10n.failureServerError);
      expect(appFailureMessageMapper(const UnknownFailure(), l10n), l10n.failureUnknown);
    });

    test('prefers serverMessage when available for BadRequest, Conflict, and UnprocessableEntity', () {
      expect(
        appFailureMessageMapper(const BadRequestFailure(serverMessage: 'Custom bad request'), l10n),
        'Custom bad request',
      );
      expect(
        appFailureMessageMapper(const BadRequestFailure(serverMessage: ''), l10n),
        l10n.failureBadRequest,
      );
      expect(
        appFailureMessageMapper(const BadRequestFailure(serverMessage: null), l10n),
        l10n.failureBadRequest,
      );

      expect(
        appFailureMessageMapper(const ConflictFailure(serverMessage: 'Custom conflict'), l10n),
        'Custom conflict',
      );
      expect(
        appFailureMessageMapper(const ConflictFailure(serverMessage: ''), l10n),
        l10n.failureConflict,
      );

      expect(
        appFailureMessageMapper(const UnprocessableEntityFailure(serverMessage: 'Custom unprocessable'), l10n),
        'Custom unprocessable',
      );
      expect(
        appFailureMessageMapper(const UnprocessableEntityFailure(serverMessage: ''), l10n),
        l10n.failureUnprocessableEntity,
      );
    });
  });
}

