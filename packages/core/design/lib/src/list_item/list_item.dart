import 'package:design/design.dart';
import 'package:flutter/material.dart';

class DesignListItem extends StatelessWidget {
  const DesignListItem({
    super.key,
    this.title,
    this.subtitle,
    this.buttonIcon,
    this.buttonOnPressed,
    this.loading = false,
  });

  // Title and subtitle are optional to allow usage when loading skeleton is shown.
  final String? title;
  final String? subtitle;
  final IconData? buttonIcon;
  final VoidCallback? buttonOnPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return _buildSkeleton(context);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                DesignText(
                  title!,
                  type: DesignTextType.body,
                  overflow: TextOverflow.ellipsis,
                ),
              if (title != null && subtitle != null)
                const SizedBox(height: 4.0),
              if (subtitle != null)
                DesignText(
                  subtitle!,
                  type: DesignTextType.caption,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        if (buttonIcon != null)
          DesignButton(
            icon: buttonIcon,
            onPressed: buttonOnPressed,
            background: false,
          ),
      ],
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    final Color base = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.08);

    Widget line(double width, double height) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(6),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;

        final double titleW = maxW * 0.5;
        final double subtitleW = maxW * 0.35;

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                line(titleW, 16),
                const SizedBox(height: 8),
                line(subtitleW, 12),
              ],
            ),
          ],
        );
      },
    );
  }
}
