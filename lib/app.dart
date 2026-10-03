import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/domain/user_session.dart';
import 'features/auth/presentation/auth_screen.dart';
import 'features/auth/presentation/auth_view_model.dart';
import 'features/home/data/catalog_repository.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/home/presentation/home_view_model.dart';

class CafeMovilApp extends StatefulWidget {
  const CafeMovilApp({
    super.key,
    required this.authRepository,
    required this.catalogRepository,
  });

  final AuthRepository authRepository;
  final CatalogRepository catalogRepository;

  @override
  State<CafeMovilApp> createState() => _CafeMovilAppState();
}

class _CafeMovilAppState extends State<CafeMovilApp> {
  UserSession? _session;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Café Móvil',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: _session == null
          ? AuthScreen(
              viewModel: AuthViewModel(repository: widget.authRepository),
              onAuthenticated: (session) => setState(() => _session = session),
            )
          : HomeScreen(
              session: _session!,
              viewModel: HomeViewModel(repository: widget.catalogRepository),
            ),
    );
  }
}
