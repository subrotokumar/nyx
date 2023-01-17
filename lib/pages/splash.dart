import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            'assets/lotties/nft-monkey.json',
            width: double.infinity,
            height: 200,
          ),
          const SizedBox(height: 12),
          const Hero(
            tag: 'splash',
            child: Text(
              'NYX',
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.overline,
              ),
            ),
          ),
          const Text(
            'NFT Galary',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
