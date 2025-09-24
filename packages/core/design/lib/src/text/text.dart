import 'package:flutter/material.dart';

enum DesignTextType { h1, h2, h3, body, caption }

class DesignText extends StatelessWidget {
  const DesignText(this.text, {super.key, this.type = DesignTextType.h3});

  final String text;
  final DesignTextType type;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: _styleFor(type));
  }

  TextStyle _styleFor(DesignTextType type) {
    switch (type) {
      case DesignTextType.h1:
        return const TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
      case DesignTextType.h2:
        return const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
      case DesignTextType.h3:
        return const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
      case DesignTextType.body:
        return const TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
      case DesignTextType.caption:
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
    }
  }
}
