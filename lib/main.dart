import 'package:flutter/material.dart';

void main() {
  runApp(const MojaApka());
}

class MojaApka extends StatelessWidget {
  const MojaApka({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Cześć, Jacek!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}