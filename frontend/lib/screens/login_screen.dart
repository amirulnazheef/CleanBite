import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedLanguage = 'en';
  final List<String> _selectedDietaryRestrictions = [];
  final List<String> _selectedAllergens = [];

  final List<String> _dietaryOptions = [
    'halal',
    'vegan',
    'vegetarian',
    'kosher',
    'gluten-free',
    'dairy-free',
  ];

  final List<String> _allergenOptions = [
    'nuts',
    'dairy',
    'gluten',
    'soy',
    'eggs',
    'shellfish',
    'fish',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final preferences = UserPreferences(
        name: _nameController.text.trim(),
        language: _selectedLanguage,
        dietaryRestrictions: _selectedDietaryRestrictions,
        allergens: _selectedAllergens,
      );

      context.read<UserProvider>().login(preferences);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _handleGuestLogin() {
    final preferences = UserPreferences(
      name: 'Guest',
      language: _selectedLanguage,
      dietaryRestrictions: [],
      allergens: [],
    );

    context.read<UserProvider>().login(preferences);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 80,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'CleanBite',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Personalize your dietary preferences',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                const Text(
                  'Preferred Language',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedLanguage,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.language),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ko', child: Text('한국어')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                  },
                ),

                const SizedBox(height: 24),

                const Text(
                  'Dietary Restrictions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _dietaryOptions.map((option) {
                    return FilterChip(
                      label: Text(option.toUpperCase()),
                      selected: _selectedDietaryRestrictions.contains(option),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedDietaryRestrictions.add(option);
                          } else {
                            _selectedDietaryRestrictions.remove(option);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Allergen Alerts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _allergenOptions.map((option) {
                    return FilterChip(
                      label: Text(option.toUpperCase()),
                      selected: _selectedAllergens.contains(option),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedAllergens.add(option);
                          } else {
                            _selectedAllergens.remove(option);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    'Save Preferences & Continue',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 16),

                OutlinedButton(
                  onPressed: _handleGuestLogin,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Continue as Guest',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Or sign in with',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Google login not implemented yet')),
                          );
                        },
                        icon: const Icon(Icons.g_mobiledata, color: Colors.red),
                        label: const Text('Google'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Apple login not implemented yet')),
                          );
                        },
                        icon: const Icon(Icons.apple, color: Colors.black),
                        label: const Text('Apple'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
