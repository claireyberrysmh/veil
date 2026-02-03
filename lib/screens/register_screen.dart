import 'package:flutter/material.dart';
import '../widgets/register_widgets/register_screen_section.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegisterSuccess;
  final VoidCallback onGoToLogin;

  const RegisterScreen({
    super.key,
    required this.onRegisterSuccess,
    required this.onGoToLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        backgroundColor: const Color(0xFF1a1a1a),
      ),
      body: RegisterScreenSection(
        onRegisterSuccess: widget.onRegisterSuccess,
        onGoToLogin: widget.onGoToLogin,
      ),
    );
  }
}
