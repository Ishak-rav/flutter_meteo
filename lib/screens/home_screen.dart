import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meteo/screens/account_screen.dart';
import 'package:meteo/screens/login_screen.dart';
import 'package:meteo/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final StreamSubscription<AuthState> _authStateSubscription;
  String _buttonText = "Login";
  Session? _session;

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _session = data.session;
        _buttonText = _session != null ? "Logout" : "Login";
      });
    });
    super.initState();
  }

  Future<void> _handleSignOut() async {
    await supabase.auth.signOut();
    setState(() {
      _session = null;
      _buttonText = "Login";
    });
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Météo App'),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_session == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else {
                _handleSignOut();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _session == null ? Colors.blue : Colors.red,
            ),
            child: Text(_buttonText),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            },
            icon: const Icon(Icons.settings),
            tooltip: 'Paramètres',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _session == null
                ? const Center(
                    child: Text(
                      'Veuillez vous identifier pour utiliser l\'application',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/google-maps.png',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WeatherScreen()),
                              );
                            },
                            child: const Text('Geolocation'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/la-meteo.png',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WeatherScreen()),
                              );
                            },
                            child: const Text('Weather'),
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
