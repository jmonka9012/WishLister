import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Potrzebne do ograniczenia wpisywania tylko cyfr
import 'package:wishlister/welcome_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Dodajemy nowy kontroler do numeru telefonu
  final _phoneController = TextEditingController();
  
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Nasłuchujemy teraz też zmian w polu telefonu
    _phoneController.addListener(_validateForm);
    _displayNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _repeatPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    bool isValid = 
        _phoneController.text.length == 9 && // Sprawdzamy czy numer ma 9 cyfr
        _displayNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _passwordController.text == _repeatPasswordController.text;

    setState(() {
      _isButtonEnabled = isValid;
    });
  }

  Future<void> _registerUser() async {
  try {
    String fullPhoneNumber = "+48${_phoneController.text.trim()}";

    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    String uid = userCredential.user!.uid;

    // Zapisujemy w bazie
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'displayName': _displayNameController.text,
      'email': _emailController.text.trim(),
      'phoneNumber': fullPhoneNumber,
      'createdAt': FieldValue.serverTimestamp(),
      'isAdmin': false,   // Domyślnie zwykły user
      'isPremium': false, // Domyślnie brak premium
    });

    print("Konto założone!");
    
    Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const WelcomeScreen()));

  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Błąd: ${e.message}')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Załóż konto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Twój numer telefonu posłuży do znalezienia znajomych.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 8),

              // --- ZMIENIONA SEKCJA NUMERU TELEFONU ---
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number, // Klawiatura numeryczna
                // Ograniczamy wpisywanie do 9 znaków i tylko cyfr
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                decoration: InputDecoration(
                  labelText: 'Numer telefonu',
                  border: const OutlineInputBorder(),
                  // To jest nasz "Dropdown" po lewej stronie
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.grey)), // Kreska oddzielająca
                    ),
                    // Używamy Row z mainAxisSize.min, żeby zajął tylko tyle miejsca ile trzeba
                    child: Row(
                      mainAxisSize: MainAxisSize.min, 
                      children: const [
                        Text("🇵🇱", style: TextStyle(fontSize: 24)), // Flaga
                        SizedBox(width: 8),
                        Text("+48", style: TextStyle(fontWeight: FontWeight.bold)),
                        Icon(Icons.arrow_drop_down, color: Colors.grey), // Ikona "disabled"
                      ],
                    ),
                  ),
                ),
              ),
              // ------------------------------------------

              const SizedBox(height: 16),
              TextField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Wyświetlana nazwa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Hasło',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _repeatPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Powtórz hasło',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isButtonEnabled ? _registerUser : null,
                  child: const Text('Załóż konto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}