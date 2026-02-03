import 'package:flutter/material.dart';
import '../widgets/login_widgets/login_screen_section.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onGoToRegister;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onGoToRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
        backgroundColor: const Color(0xFF1a1a1a),
      ),
      body: LoginScreenSection(
        onLoginSuccess: widget.onLoginSuccess,
        onGoToRegister: widget.onGoToRegister,
      ),
    );
  }
}
