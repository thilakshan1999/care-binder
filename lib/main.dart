import 'package:care_sync/src/screens/login/loginScreen.dart';
import 'package:care_sync/src/theme/darkTheme.dart';
import 'package:care_sync/src/theme/lightTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/bloc/blockProvider.dart';
import 'src/bloc/userBloc.dart';
import 'src/screens/document/documentScreen.dart';
import 'src/screens/splashScreen/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: BlocProviders.providers(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CareSync',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: const AppEntry(),
    );
  }
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _showSplash
          ? const SplashScreen(key: ValueKey('splash'))
          : context.read<UserBloc>().state.isLoggedIn
              ? const DocumentScreen(key: ValueKey('document'))
              : const LoginScreen(key: ValueKey('login')),
    );
  }
}
