import 'package:flutter/material.dart';
import 'side_menu.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WishLister"),
        centerTitle: true,
      ),
      
      // 3. TUTAJ PODPINAMY NASZE NOWE MENU
      drawer: const SideMenu(currentRoute: 'home'),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Witamy w Wishlister! To jest strona główna, w przyszłości prawdopobonie damy tu jakieś aktualności, co nowego chcą znajomi, albo widok naszej listy - zobaczymy. No i pewnie zmienimy te cringową nazwę.',
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