// ==============================================================================
// One Numan Public School (ONPS) — Android Scholastic ERP Mobile Application
// Main Entrypoint
// Visual Design: Espresso Heritage Academic System
// Django 5.1.4 Backend Mirroring Architecture
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'data/mock/auth_state.dart';
import 'router.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Android Status & Navigation Bar Configuration
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AcademicColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const OnpsErpApp());
}

class OnpsErpApp extends StatefulWidget {
  const OnpsErpApp({super.key});

  @override
  State<OnpsErpApp> createState() => _OnpsErpAppState();
}

class _OnpsErpAppState extends State<OnpsErpApp> {
  late final AuthState _authState;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authState = AuthState();
    _router = createOnpsRouter(_authState);
  }

  @override
  void dispose() {
    _authState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthState>.value(
      value: _authState,
      child: MaterialApp.router(
        title: 'One Numan Alpha',
        debugShowCheckedModeBanner: false,
        theme: AcademicTheme.themeData,
        routerConfig: _router,
      ),
    );
  }
}
