
import 'package:aura_app/ext/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableText extends StatelessWidget {
  final String textToCopy;
  final Widget child;

  const CopyableText({
    required this.textToCopy,
    required this.child,
    super.key,
  });

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: textToCopy));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(context.l10n.copiedToClipboard),
              const SizedBox(width: 8),
              const Icon(Icons.copy, color: Colors.white, size: 16),
            ],
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          width: 225,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: () => _copyToClipboard(context),
    child: child,
  );
}
