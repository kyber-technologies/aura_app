import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OverlayButton extends HookWidget {
  final Widget child;
  final Widget overlayChild;
  final VoidCallback onTap;
  final double borderRadius;

  const OverlayButton({
    required this.child,
    required this.overlayChild,
    required this.onTap,
    this.borderRadius = 12.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isHovered = useState<bool>(false);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5),
                child: child,
              ),
              Positioned.fill(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  opacity: isHovered.value ? 1.0 : 0.0,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: Center(
                      child: overlayChild,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
