import 'package:flutter/material.dart';

class _PressedEffectWrapper extends StatefulWidget {
  const _PressedEffectWrapper({
    required this.child,
    required this.enabled,
    required this.borderRadius,
    this.showShadow = true,
  });

  final Widget child;
  final bool enabled;
  final BorderRadius borderRadius;
  final bool showShadow;

  @override
  State<_PressedEffectWrapper> createState() => _PressedEffectWrapperState();
}

class _PressedEffectWrapperState extends State<_PressedEffectWrapper> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!widget.enabled) {
      return;
    }
    if (_pressed != value) {
      setState(() {
        _pressed = value;
      });
    }
  }

  List<BoxShadow> _shadows(double t) {
    final normalAlpha = (0.18 * (1 - t) + 0.08 * t).clamp(0.0, 1.0);
    final innerAlpha = (0.00 * (1 - t) + 0.16 * t).clamp(0.0, 1.0);
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: normalAlpha),
        blurRadius: 8 * (1 - t) + 3 * t,
        offset: Offset(0, 3 * (1 - t) + 1 * t),
      ),
      if (t > 0)
        BoxShadow(
          color: Colors.black.withValues(alpha: innerAlpha),
          blurRadius: 5,
          offset: const Offset(0, 1),
          blurStyle: BlurStyle.inner,
        ),
    ];
  }

  ColorFilter _darkenFilter(double factor) {
    return ColorFilter.matrix(<double>[
      factor, 0, 0, 0, 0,
      0, factor, 0, 0, 0,
      0, 0, factor, 0, 0,
      0, 0, 0, 1, 0,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final duration = Duration(milliseconds: _pressed ? 100 : 150);

    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: _pressed ? 1 : 0),
        duration: duration,
        curve: Curves.easeOut,
        child: widget.child,
        builder: (context, t, child) {
          final scale = 1 - (0.03 * t);
          final dy = 2 * t;
          final darkenFactor = 1 - (0.10 * t);

          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              boxShadow: widget.showShadow ? _shadows(t) : null,
            ),
            child: Transform.translate(
              offset: Offset(0, dy),
              child: Transform.scale(
                scale: scale,
                child: ColorFiltered(
                  colorFilter: _darkenFilter(darkenFactor),
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WestElevatedButton extends StatelessWidget {
  const WestElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.disablePressedEffect = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final bool disablePressedEffect;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );
    if (disablePressedEffect) {
      return button;
    }
    return _PressedEffectWrapper(
      enabled: onPressed != null,
      borderRadius: BorderRadius.circular(16),
      child: button,
    );
  }
}

class WestTextButton extends StatelessWidget {
  const WestTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return _PressedEffectWrapper(
      enabled: onPressed != null,
      borderRadius: BorderRadius.circular(12),
      child: TextButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    );
  }
}

class WestIconButton extends StatelessWidget {
  const WestIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.disablePressedEffect = false,
    this.disablePressedShadow = false,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String? tooltip;
  final bool disablePressedEffect;
  final bool disablePressedShadow;

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      onPressed: onPressed,
      icon: icon,
      tooltip: tooltip,
    );
    if (disablePressedEffect) {
      return button;
    }
    return _PressedEffectWrapper(
      enabled: onPressed != null,
      borderRadius: BorderRadius.circular(999),
      showShadow: !disablePressedShadow,
      child: button,
    );
  }
}
