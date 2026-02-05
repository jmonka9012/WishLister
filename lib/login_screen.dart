import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  // Pusta funkcja logowania (uzupełnimy w następnym kroku)
  Future<void> _loginUser() async {
    // 1. Blokujemy przycisk i pokazujemy kręciołek
    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Strzał do Firebase (to może potrwać sekundę)
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text
            .trim(), // trim() usuwa spacje, jeśli user wkleił maila
        password: _passwordController.text,
      );

      // 3. Jeśli kod doszedł tu, to znaczy, że nie było błędu!
      print("SUKCES: Użytkownik zalogowany!");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Zalogowano pomyślnie!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      }

    } on FirebaseAuthException catch (e) {
      // 4. Obsługa błędów (np. złe hasło, brak internetu)
      print("BŁĄD: ${e.code}");

      String message = "Wystąpił błąd logowania";

      // Tłumaczenie błędów na polski
      if (e.code == 'user-not-found') {
        message = "Nie ma takiego użytkownika.";
      } else if (e.code == 'wrong-password') {
        // Uwaga: Firebase czasem zwraca ogólny błąd dla bezpieczeństwa
        message = "Błędne hasło.";
      } else if (e.code == 'invalid-email') {
        message = "Błędny format emaila.";
      } else if (e.code == 'invalid-credential') {
        message = "Błędne dane logowania.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      // Inne błędy (np. brak internetu w telefonie)
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Błąd połączenia."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // 5. Na koniec ZAWSZE odblokowujemy przycisk (nieważne czy sukces, czy błąd)
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
          // Wyśrodkowanie góra-dół
          child: SingleChildScrollView(
            // Żeby klawiatura nie zasłaniała pól
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Pole Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress, // Klawiatura z @
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),

                const SizedBox(height: 16), // Odstęp
                // 2. Pole Hasło
                TextField(
                  controller: _passwordController,
                  obscureText: true, // Ukrywanie znaków (kropki)
                  decoration: const InputDecoration(
                    labelText: 'Hasło',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),

                const SizedBox(height: 24), // Większy odstęp przed przyciskiem
                // 3. Przycisk Logowania
                SizedBox(
                  width: double.infinity, // Rozciągnij na szerokość
                  height: 50,
                  child: ElevatedButton(
                    // Jeśli _isLoading jest true, przycisk jest nieaktywny (null)
                    onPressed: _isLoading ? null : _loginUser,
                    child: _isLoading
                        ? const CircularProgressIndicator() // Kręciołek jak ładuje
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
} // Koniec klasy
