import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:care_sync/src/screens/login/loginScreen.dart';
import 'package:care_sync/src/theme/darkTheme.dart';
import 'package:care_sync/src/theme/lightTheme.dart';
import 'package:care_sync/src/utils/shareHandler.dart';
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
  StreamSubscription? _linkSub;
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    startSplash();
  }

  Future<void> startSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      initDeepLinkListener();
      setState(() => _showSplash = false);
    }
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinkListener() async {
    _appLinks = AppLinks();
    print('🧊 Init Deep Link');
    // 🔹 Handle cold start (app launched via deep link)
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleUri(initialUri);
    }

     // Listen for links while app is running/resumed
    _linkSub = _appLinks.uriLinkStream.listen(
      (uri) => _handleUri(uri),
      onError: (err) => print('❌ Deep link error: $err'),
    );
  }

  void _handleUri(Uri uri) {
    // ✅ Avoid reprocessing same link
    if (ShareHandler.lastHandledUri == uri) {
      print('⚪ Skipping duplicate deep link: $uri');
      return;
    }
    ShareHandler.lastHandledUri = uri;

    print('🔥 Handling deep link: $uri');
    if(context.read<UserBloc>().state.isLoggedIn){
      ShareHandler.handleIncomingShare(context, uri);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return 
    AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _showSplash
          ? const SplashScreen(key: ValueKey('splash'))
          : context.read<UserBloc>().state.isLoggedIn
              ? const DocumentScreen(key: ValueKey('document'))
              : const LoginScreen(key: ValueKey('login')),
    );
  }
}

