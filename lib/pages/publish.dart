import 'package:flutter/material.dart';

class PublishPage extends StatelessWidget {
  const PublishPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('发布')),
      body: const Center(
        child: Text('发布'),
      ),
    );
  }
}
