import 'package:flutter/material.dart';

class DesignButton extends StatelessWidget {
  const DesignButton({
    super.key,
    this.labelText,
    this.onPressed,
    this.icon,
    this.background = true,
    this.loading = false,
  });

  final String? labelText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool background;
  // When true, show a small progress indicator and disable the button.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = loading || onPressed == null;

    return OutlinedButton(
      style: background == false
          ? OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            )
          : OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              side: BorderSide.none,
              backgroundColor: Colors.black.withValues(alpha: 0.05),
            ),
      onPressed: isDisabled ? null : onPressed,
      child: Row(
        children: [
          if (loading) ...[
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ] else ...[
            if (icon != null) Icon(icon, size: 24, color: Colors.black),
            if (icon != null && labelText != null) const SizedBox(width: 4),
            if (labelText != null)
              Text(labelText!, style: TextStyle(color: Colors.black)),
          ],
        ],
      ),
    );
  }
}
