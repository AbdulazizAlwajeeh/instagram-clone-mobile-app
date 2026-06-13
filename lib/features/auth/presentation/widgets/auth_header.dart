import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Instagram',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
    );
  }
}
