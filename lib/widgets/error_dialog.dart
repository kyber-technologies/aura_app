import 'package:aura_app/ext/common.dart';
import 'package:aura_app/ext/widgets.dart';
import 'package:aura_app/grpc/exception.dart';
import 'package:aura_app/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ErrorDialog extends HookConsumerWidget {
  final Exception error;
  final Map<ServiceErrorType, String> translations;

  const ErrorDialog(this.error, this.translations, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (String, String) errorDesc = useMemoized(() {
      if (error is ServiceException) {
        final ServiceException exception = error as ServiceException;
        final ServiceErrorType type = exception.error.whichType();
        final String? translation = type == ServiceErrorType.rateLimit
            ? context.l10n.rateLimitError
            : translations[type];

        if (translation != null) {
          return (exception.error.code(), translation);
        } else {
          return (exception.error.code(), error.toString());
        }
      } else {
        return (context.l10n.unexpectedError, error.toString());
      }
    });

    useMemoized(() {
      logger.e('${errorDesc.$1}: ${errorDesc.$2}');
    });

    return Dialog(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(errorDesc.$1, textAlign: TextAlign.center)
                  .bodyLarge(context)
                  .error(context)
                  .copyWithStyle(fontWeight: FontWeight.bold),
              Text(
                errorDesc.$2,
                textAlign: TextAlign.center,
              ).bodyLarge(context).error(context),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.l10n.close),
              ),
            ],
          ),
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
