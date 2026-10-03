import 'package:flutter/material.dart';

import '../domain/user_session.dart';
import 'auth_view_model.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.viewModel, required this.onAuthenticated});

  final AuthViewModel viewModel;
  final ValueChanged<UserSession> onAuthenticated;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _validationMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    try {
      final session = await widget.viewModel.register(
        name: _nameController.text,
        phone: _phoneController.text,
      );
      widget.onAuthenticated(session);
    } on ArgumentError {
      setState(() => _validationMessage = 'Nombre y celular son obligatorios');
    } catch (_) {
      setState(() => _validationMessage = 'No fue posible registrar el usuario');
    }
  }

  Future<void> _continueAsGuest() async {
    try {
      final session = await widget.viewModel.continueAsGuest();
      widget.onAuthenticated(session);
    } catch (_) {
      setState(() => _validationMessage = 'No fue posible entrar como invitado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        final isLoading = widget.viewModel.isLoading;
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 32),
                Icon(Icons.coffee, size: 64, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  'Café Móvil',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Encuentra cafés colombianos por marca, presentación y categoría.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextField(
                  key: const ValueKey('nameField'),
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Nombre', prefixIcon: Icon(Icons.person_outline)),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const ValueKey('phoneField'),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Celular', prefixIcon: Icon(Icons.phone_android)),
                ),
                const SizedBox(height: 16),
                if (_validationMessage != null) ...[
                  Text(_validationMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  const SizedBox(height: 12),
                ],
                FilledButton.icon(
                  onPressed: isLoading ? null : _register,
                  icon: const Icon(Icons.login),
                  label: const Text('Registrarme'),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: isLoading ? null : _continueAsGuest,
                  icon: const Icon(Icons.person_pin_circle_outlined),
                  label: const Text('Entrar como invitado'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
