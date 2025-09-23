import 'package:flutter/material.dart';

class DefaultNotFound extends StatelessWidget {
  const DefaultNotFound({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('404: $path')));
  }
}
