import 'package:design/design.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DesignTextField(
                      urlController: _urlController,
                      labelText: 'Enter URL',
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  DesignButton(icon: Icons.send, onPressed: () {}),
                ],
              ),
              const SizedBox(height: 24.0),
              DesignText('Recently Shortened URLs', type: DesignTextType.h3),
              Expanded(
                child: ListView.separated(
                  itemCount: 15,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return DesignListItem(
                      title: 'Short URL $index',
                      subtitle: 'https://short.url/$index',
                      buttonIcon: Icons.copy,
                      buttonOnPressed: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
