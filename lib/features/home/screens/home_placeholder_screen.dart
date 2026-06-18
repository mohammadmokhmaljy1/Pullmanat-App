import 'package:flutter/material.dart';

/// شاشة مؤقتة بعد انتهاء البداية — ستُستبدل لاحقاً بشاشة Getting Started
class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بين المدن'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'مرحباً بك في تطبيق بين المدن',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
