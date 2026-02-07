// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _aboutController = TextEditingController();
  // Inicjalizacja listy. Jeśli tu wywali błąd -> zrób STOP i START aplikacji
  final List<TextEditingController> _preferenceControllers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addNewPreferenceField();
  }

  void _addNewPreferenceField() {
    final controller = TextEditingController();
    controller.addListener(() {
      if (_preferenceControllers.isNotEmpty && 
          controller == _preferenceControllers.last && 
          controller.text.isNotEmpty) {
        setState(() {
          _addNewPreferenceField();
        });
      }
    });
    _preferenceControllers.add(controller);
  }

  Future<void> _submitData() async {
    setState(() => _isLoading = true);

    try {

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Błąd autoryzacji.");

      // 1. Filtrujemy puste pola preferencji
      List<String> validPreferences = _preferenceControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      // 2. WYSYŁKA DO BAZY + FLAGA UKOŃCZENIA
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'aboutMe': _aboutController.text.trim(),
        'preferences': validPreferences,
        'isProfileCompleted': true, 
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil gotowy!"), backgroundColor: Colors.green),
        );
        
        // Przekierowanie do Home
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }

    } catch (e) {
      if (mounted) {
        String msg = e.toString().replaceAll("Exception: ", "");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _aboutController.dispose();
    for (var c in _preferenceControllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Witaj w WishLister!"), // Inny tytuł w AppBar
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. NAGŁÓWEK EKRANU
              const Text(
                'Uzupełnij swój profil',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), //ds
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // 2. TEKST OPISOWY
              const Text(
                'Napisz kilka słów o sobie i wymień co lubisz. Dzięki temu znajomi będą wiedzieć, jaką niespodziankę Ci sprawić jeżeli będą chcieli kupić coś spoza Twojej listy życzeń, lub będą mieli wątpliwości co do cech chcianego przez Ciebie prezentu. Możesz też zostawić te wszystkie pola puste jeżeli chcesz ich sprawdzić... ;)',
                style: TextStyle(fontSize: 16, color: Colors.grey), //ds
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // 3. INPUT "O MNIE"
              TextField(
                controller: _aboutController,
                maxLength: 255,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'O mnie',
                  hintText: 'Np. Uwielbiam makabrę i stópki...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),

              // 4. REPEATER (Zrobiony na pętli for - bezpieczniejszy)
              const Text(
                "Twoje preferencje",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              
              // Pętla generująca pola
              for (int i = 0; i < _preferenceControllers.length; i++) 
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextField(
                    controller: _preferenceControllers[i],
                    decoration: InputDecoration(
                      labelText: 'Preferencja #${i + 1}',
                      prefixIcon: const Icon(Icons.star_border),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // 5. PRZYCISK ZATWIERDŹ
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitData,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Zapisz i wejdź', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}