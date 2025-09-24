import 'package:design/design.dart';
import 'package:flutter/material.dart';

/// A simple empty state widget for list screens.
///
/// Displays an optional [icon], a required [title], an optional [description]
/// and an optional action button defined by [actionLabel] and [onAction].
class DesignEmpty extends StatelessWidget {
  const DesignEmpty({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.all(24),
  });

  /// The main title text.
  final String title;

  /// An optional supporting description below the title.
  final String? description;

  /// Optional icon to illustrate the empty state.
  final IconData? icon;

  /// Optional action button label. If provided, an action button is rendered.
  final String? actionLabel;

  /// Callback for the optional action button. If null, the button is disabled.
  final VoidCallback? onAction;

  /// Outer padding for the whole empty state.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final Color tint = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.4);

    return Center(
      child: Padding(
        padding: padding,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon ?? Icons.inbox_outlined, size: 48, color: tint),
              const SizedBox(height: 12),
              DesignText(title, type: DesignTextType.h3),
              if (description != null) ...[
                const SizedBox(height: 8),
                Text(
                  description!,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionLabel != null) ...[
                const SizedBox(height: 16),
                DesignButton(labelText: actionLabel, onPressed: onAction),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
