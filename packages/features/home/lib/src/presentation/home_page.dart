import 'package:create/create.dart';
import 'package:flutter/material.dart';
import 'package:history/history.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CreateWidget(),
              const SizedBox(height: 24.0),
              Expanded(child: HistoryWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
