import 'package:flutter/material.dart';

class LembretesScreen extends StatelessWidget {
  const LembretesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lembretes')),
      body: const Center(child: Text('Lembretes')),
    );
  }
}