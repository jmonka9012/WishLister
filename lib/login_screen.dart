import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 1. Potrzebne do sprawdzenia bazy
import 'home_screen.dart';
import 'welcome_screen.dart'; // 2. Potrzebne do przekierowania

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // A. Logowanie w Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // B. Jeśli logowanie przeszło, sprawdzamy bazę danych Firestore
      User user = userCredential.user!;
      
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      bool isProfileCompleted = false;

      // Sprawdzamy czy dokument istnieje i czy ma flagę
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        isProfileCompleted = data['isProfileCompleted'] ?? false;
      }

      print("SUKCES: Zalogowano. Profil uzupełniony: $isProfileCompleted");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Zalogowano pomyślnie!"),
            backgroundColor: Colors.green,
          ),
        );

        // C. Decyzja gdzie przekierować
        // Używamy pushReplacement, żeby nie dało się cofnąć do logowania strzałką
        if (isProfileCompleted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }
      }

    } on FirebaseAuthException catch (e) {
      // Obsługa błędów Firebase
      String message = "Wystąpił błąd logowania";

      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        message = "Błędny email lub hasło.";
      } else if (e.code == 'wrong-password') {
        message = "Błędne hasło.";
      } else if (e.code == 'invalid-email') {
        message = "Błędny format emaila.";
      } else if (e.code == 'too-many-requests') {
        message = "Za dużo prób logowania. Spróbuj później.";
      }

      print("BŁĄD FIREBASE: ${e.code}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      // Inne błędy (np. brak internetu przy pobieraniu profilu)
      print("BŁĄD OGÓLNY: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Błąd połączenia. Sprawdź internet."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Zaloguj się")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Hasło',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _loginUser,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Zaloguj się'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}