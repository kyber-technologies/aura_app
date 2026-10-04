import 'package:aura_app/ext.dart';
import 'package:aura_app/grpc/exception.dart';
import 'package:aura_app/logger.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final Exception error;
  final Map<ServiceErrorType, String> translations;

  const ErrorDialog(this.error, this.translations, {super.key});

  @override
  Widget build(BuildContext context) {
    late final String errorDesc;

    if (error is ServiceException) {
      final ServiceException exception = error as ServiceException;
      final String? translation = translations[exception.error.whichType()];

      if (translation != null) {
        errorDesc = '${exception.error.code()} - $translation';
      } else {
        errorDesc = '${exception.error.code()} - $error';
      }
    } else {
      errorDesc = '${context.l10n.unexpectedError} - $error';
    }

    logger.e(errorDesc);

    return Dialog(
      child: SizedBox(
        child: Column(
          children: <Widget>[
            Text(errorDesc).title(context).error(context),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10n.close),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => ErrorDialog(error, translations),
    );
  }
}
