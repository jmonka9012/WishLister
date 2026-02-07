import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'side_menu.dart';

class MyPreferencesScreen extends StatefulWidget {
  const MyPreferencesScreen({super.key});

  @override
  State<MyPreferencesScreen> createState() => _MyPreferencesScreenState();
}

class _MyPreferencesScreenState extends State<MyPreferencesScreen> {
  final _aboutController = TextEditingController();
  final List<TextEditingController> _preferenceControllers = [];
  bool _isLoading = false;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Funkcja do pobrania danych z Firebase i uzupełnienia pól
  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;

        // Uzupełniamy "O mnie"
        if (data.containsKey('aboutMe')) {
          _aboutController.text = data['aboutMe'];
        }

        // Uzupełniamy listę preferencji
        if (data.containsKey('preferences')) {
          List<dynamic> prefs = data['preferences'];
          for (String pref in prefs) {
            _addPreferenceField(initialText: pref);
          }
        }
      }
    } catch (e) {
      print("Błąd pobierania danych: $e");
    } finally {
      _addPreferenceField();
      
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  void _addPreferenceField({String? initialText}) {
    final controller = TextEditingController(text: initialText);
    
    controller.addListener(() {
      if (_preferenceControllers.isNotEmpty &&
          controller == _preferenceControllers.last &&
          controller.text.isNotEmpty) {
        setState(() {
          _addPreferenceField();
        });
      }
    });

    setState(() {
      _preferenceControllers.add(controller);
    });
  }

  Future<void> _saveData() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Błąd autoryzacji.");

      // 1. Filtrujemy puste pola
      List<String> validPreferences = _preferenceControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      // 2. Aktualizacja w bazie
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'aboutMe': _aboutController.text.trim(),
        'preferences': validPreferences,
      });

      if (mounted) {
        // Sukces - SnackBar na dole
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Zapisano zmiany pomyślnie!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        FocusScope.of(context).unfocus();
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Błąd zapisu: $e"), backgroundColor: Colors.red),
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
        title: const Text("Moje Preferencje"),
        centerTitle: true,
      ),
      
      // Nasze SideMenu z zaznaczoną opcją preferences
      drawer: const SideMenu(currentRoute: "preferences"),

      body: _isInitialLoading 
          ? const Center(child: CircularProgressIndicator()) // Kręciołek podczas pobierania
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Edytuj swój profil',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Tutaj możesz zaktualizować informacje o sobie i zmienić listę rzeczy, które lubisz.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Pola tekstowe
                    TextField(
                      controller: _aboutController,
                      maxLength: 255,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'O mnie',
                        alignLabelWithHint: true,
                        // style brane z globalnego theme.dart
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Twoje preferencje",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),

                    // Lista preferencji
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

                    // Przycisk Zapisz
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveData,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Zapisz'),
                      ),
                    ),
                    // Dodatkowy odstęp na dole, żeby klawiatura nie zasłaniała
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }
}