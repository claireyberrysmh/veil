import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterScreenSection extends StatefulWidget {
  final VoidCallback onRegisterSuccess;
  final VoidCallback onGoToLogin;

  const RegisterScreenSection({
    super.key,
    required this.onRegisterSuccess,
    required this.onGoToLogin,
  });

  @override
  State<RegisterScreenSection> createState() => _RegisterScreenSectionState();
}

class _RegisterScreenSectionState extends State<RegisterScreenSection> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _errorMessage = null;
    });

    if (username.isEmpty) {
      setState(() => _errorMessage = 'Пожалуйста, введите логин');
      return;
    }

    if (username.length < 3) {
      setState(
        () => _errorMessage = 'Логин должен содержать минимум 3 символа',
      );
      return;
    }

    if (password.isEmpty) {
      setState(() => _errorMessage = 'Пожалуйста, введите пароль');
      return;
    }

    if (password.length < 6) {
      setState(
        () => _errorMessage = 'Пароль должен содержать минимум 6 символов',
      );
      return;
    }

    if (password != confirmPassword) {
      setState(() => _errorMessage = 'Пароли не совпадают');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await AuthService.register(username, password);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Регистрация успешна! Войдите в свой аккаунт.'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onGoToLogin();
      } else {
        setState(
          () => _errorMessage = 'Логин уже существует. Выберите другой логин.',
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Ошибка при регистрации: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.security, size: 80, color: Colors.green),
            const SizedBox(height: 32),
            const Text(
              'Создать новый аккаунт',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Логин',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabled: !_isLoading,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Пароль',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabled: !_isLoading,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Подтвердить пароль',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabled: !_isLoading,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isLoading ? null : _handleRegister,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Зарегистрироваться',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Уже есть аккаунт? '),
                TextButton(
                  onPressed: _isLoading ? null : widget.onGoToLogin,
                  child: const Text(
                    'Войти',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
