import 'package:flutter/material.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code')),
      body: const Center(child: Text('QR Code')),
    );
  }
}