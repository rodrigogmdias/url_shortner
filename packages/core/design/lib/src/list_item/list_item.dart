import 'package:design/design.dart';
import 'package:flutter/material.dart';

class DesignListItem extends StatelessWidget {
  const DesignListItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonIcon,
    this.buttonOnPressed,
  });

  final String title;
  final String subtitle;
  final IconData? buttonIcon;
  final VoidCallback? buttonOnPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DesignText(title, type: DesignTextType.body),
            SizedBox(height: 4.0),
            DesignText(subtitle, type: DesignTextType.caption),
          ],
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
}
