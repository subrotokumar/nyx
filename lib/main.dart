import 'package:flutter/material.dart';
import 'package:nyx/pages/splash.dart';
import './pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NYX : NFT Galary',
      theme: ThemeData.dark(),
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
