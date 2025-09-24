import 'package:flutter/material.dart';

class DesignButton extends StatelessWidget {
  const DesignButton({
    super.key,
    this.labelText,
    this.onPressed,
    this.icon,
    this.background = true,
  });

  final String? labelText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool background;

  @override
  Widget build(BuildContext context) {
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
      onPressed: onPressed,
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 24, color: Colors.black),
          if (icon != null && labelText != null) const SizedBox(width: 4),
          if (labelText != null)
            Text(labelText!, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
