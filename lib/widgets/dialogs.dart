import 'dart:async';

import 'package:aura_app/ext/common.dart';
import 'package:aura_app/ext/widgets.dart';
import 'package:aura_app/grpc/exception.dart';
import 'package:aura_app/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EditDialog extends HookWidget {
  final String initialValue;
  final String label;
  final FutureOr<void> Function(String) onSubmit;
  final String? Function(String?)? validator;
  final FutureOr<void> Function()? onCancel;
  final bool multiline;
  final bool barrierDismissable;

  const EditDialog({
    required this.label,
    required this.onSubmit,
    this.validator,
    this.onCancel,
    this.initialValue = '',
    this.multiline = false,
    this.barrierDismissable = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = useTextEditingController.fromValue(
      TextEditingValue(text: initialValue),
    );

    final ValueNotifier<String?> error = useState<String?>(null);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 600,
          minHeight: 100,
          maxHeight: 300,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: <Widget>[
              Text(label).titleLarge(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(errorText: error.value),
                  onChanged: (String? text) {
                    error.value = validator?.call(text);
                  },
                  minLines: 1,
                  maxLines: multiline ? 5 : 1,
                  keyboardType: multiline
                      ? TextInputType.multiline
                      : TextInputType.text,
                  textInputAction: multiline ? TextInputAction.newline : null,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      error.value = validator?.call(controller.text);

                      if (error.value == null) {
                        await onSubmit(controller.text);

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: Text(context.l10n.submit).title(context),
                  ),
                  TextButton(
                    onPressed: () async {
                      await onCancel?.call();

                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      context.l10n.cancel,
                    ).title(context).error(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> show(BuildContext context) async {
    await showDialog<void>(
      barrierDismissible: barrierDismissable,
      context: context,
      builder: (BuildContext context) => EditDialog(
        label: label,
        onSubmit: onSubmit,
        initialValue: initialValue,
        validator: validator,
        onCancel: onCancel,
        multiline: multiline,
        barrierDismissable: barrierDismissable,
      ),
    );
  }
}

class ErrorDialog extends HookWidget {
  final Exception error;
  final Map<ServiceErrorType, String> translations;

  const ErrorDialog(this.error, this.translations, {super.key});

  @override
  Widget build(BuildContext context) {
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 600,
          minHeight: 50,
          maxHeight: 300,
        ),
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
