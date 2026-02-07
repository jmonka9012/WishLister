import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'friends_screen.dart';
import 'signin_screen.dart';
import 'settings_screen.dart';
import 'mylist_screen.dart';
import 'mypreferences_screen.dart';

class SideMenu extends StatelessWidget {
  final String currentRoute;

  const SideMenu({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  margin: EdgeInsets.zero, 
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // const SizedBox(height: 80),
                      Text(
                        'Menu',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                ListTile(
                  selected: currentRoute == 'home',
                  leading: const Icon(Icons.home),
                  title: const Text('Strona główna'),
                  onTap: () {
                    if (currentRoute == 'home') {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    }
                  },
                ),
                ListTile(
                  selected: currentRoute == 'mylist',
                  leading: const Icon(Icons.list),
                  title: const Text('Moja lista'),
                  onTap: () {
                    if (currentRoute == 'mylist') {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const MyListScreen()),
                      );
                    }
                  },
                ),
                ListTile(
                  selected: currentRoute == 'preferences',
                  leading: const Icon(Icons.favorite),
                  title: const Text('Moje preferencje'),
                  onTap: () {
                    if (currentRoute == 'preferences') {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const MyPreferencesScreen()),
                      );
                    }
                  },
                ),
                ListTile(
                  selected: currentRoute == 'friends',
                  leading: const Icon(Icons.people),
                  title: const Text('Znajomi'),
                  onTap: () {
                    if (currentRoute == 'friends') {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const FriendsScreen()),
                      );
                    }
                  },
                ),
                ListTile(
                  selected: currentRoute == 'settings',
                  leading: const Icon(Icons.settings),
                  title: const Text('Ustawienia'),
                  onTap: () {
                    if (currentRoute == 'settings') {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    }
                  },
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
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}