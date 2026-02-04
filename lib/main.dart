import 'package:flutter/material.dart';

void main() {
  runApp(const WishLister());
}

class WishLister extends StatelessWidget {
  const WishLister({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Cześć, Jacek! Test',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}