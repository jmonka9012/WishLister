import 'package:flutter/material.dart';
import 'side_menu.dart'; 

class MyPreferencesScreen extends StatefulWidget {
  const MyPreferencesScreen({super.key});

  @override
  State<MyPreferencesScreen> createState() => _MyPreferencesScreenState();
}

class _MyPreferencesScreenState extends State<MyPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WishLister"),
        centerTitle: true,
      ),
      
      // 3. TUTAJ PODPINAMY NASZE NOWE MENU
      drawer: const SideMenu(), 
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Moje preferencje',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}