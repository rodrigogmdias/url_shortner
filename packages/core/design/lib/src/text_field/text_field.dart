import 'package:flutter/material.dart';

class DesignTextField extends StatelessWidget {
  const DesignTextField({
    super.key,
    required this.labelText,
    required TextEditingController urlController,
  }) : _urlController = urlController;

  final String labelText;
  final TextEditingController _urlController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _urlController,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: labelText,
        fillColor: Colors.black.withValues(alpha: 0.05),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
          gapPadding: 0,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        isDense: true,
      ),
    );
  }
}
