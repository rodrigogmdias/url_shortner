import 'package:flutter/material.dart';

class DesignSkeleton extends StatelessWidget {
  const DesignSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.color,
  }) : _shape = BoxShape.rectangle;

  const DesignSkeleton.circle({super.key, required double diameter, this.color})
    : width = diameter,
      height = diameter,
      borderRadius = null,
      _shape = BoxShape.circle;

  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? color;

  final BoxShape _shape;

  @override
  Widget build(BuildContext context) {
    final Color resolved =
        color ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08);

    final BorderRadius resolvedRadius =
        borderRadius ?? const BorderRadius.all(Radius.circular(6));

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: resolved,
        shape: _shape,
        borderRadius: _shape == BoxShape.circle ? null : resolvedRadius,
      ),
    );
  }
}
