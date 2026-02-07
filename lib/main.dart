import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Potrzebne do bazy
import 'firebase_options.dart';

// Importy Twoich ekranów
import 'theme.dart';
import 'signin_screen.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wishlister',
      theme: AppTheme.lightTheme,
      // Czy jest zalogowany?
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Jeśli użytkownik jest zalogowany
          if (authSnapshot.hasData) {
            final User user = authSnapshot.data!;

            // Co ma w bazie danych? (Future)
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.exists) {
                  // Rzutujemy dane na mapę
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  // Czytamy zmienną (jeśli jej nie ma, przyjmujemy false)
                  bool isProfileCompleted = data['isProfileCompleted'] ?? false;

                  if (isProfileCompleted) {
                    return const HomeScreen(); // Profil gotowy -> idź do domu
                  }
                }

                return const WelcomeScreen();
              },
            );
          }

          return const SignInScreen();
        },
      ),
    );
  }
}
