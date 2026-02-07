import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'friends_screen.dart';
import 'signin_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // 1. Zmieniamy główny kontener na Column
      child: Column(
        children: [
          // 2. To jest nasza sekcja "mt-auto" dla reszty.
          // Expanded sprawia, że ta lista zajmie całą dostępną przestrzeń
          // spychając to, co pod nią, na sam dół.
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Menu',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Moja lista'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('Moje preferencje'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Znajomi'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FriendsScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Ustawienia'),
                  onTap: () {},
                ),
              ],
            ),
          ),

          SafeArea(
            top: false,
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Wyloguj się'),
              onTap: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
