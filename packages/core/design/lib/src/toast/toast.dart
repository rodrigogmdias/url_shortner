import 'package:flutter/material.dart';

enum DesignToastType { success, warning, error }

class DesignToast {
  const DesignToast._();

  static void show(
    BuildContext context, {
    required String message,
    DesignToastType type = DesignToastType.success,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    bool hideCurrent = true,
  }) {
    final theme = Theme.of(context);
    final color = _bgColor(theme, type);
    final icon = _icon(type);

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    if (hideCurrent) messenger.hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      duration: duration,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      action: (actionLabel != null && onAction != null)
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onAction,
              textColor: Colors.white,
            )
          : null,
    );

    messenger.showSnackBar(snackBar);
  }

  static void success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) => show(
    context,
    message: message,
    type: DesignToastType.success,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  static void warning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) => show(
    context,
    message: message,
    type: DesignToastType.warning,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  static void error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) => show(
    context,
    message: message,
    type: DesignToastType.error,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  static Color _bgColor(ThemeData theme, DesignToastType type) {
    switch (type) {
      case DesignToastType.success:
        return Colors.green.shade600;
      case DesignToastType.warning:
        return Colors.orange.shade700;
      case DesignToastType.error:
        return Colors.red.shade600;
    }
  }

  static IconData _icon(DesignToastType type) {
    switch (type) {
      case DesignToastType.success:
        return Icons.check_circle_outline;
      case DesignToastType.warning:
        return Icons.warning_amber_rounded;
      case DesignToastType.error:
        return Icons.error_outline;
    }
  }
}
