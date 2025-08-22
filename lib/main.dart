import 'package:care_sync/src/screens/login/loginScreen.dart';
import 'package:care_sync/src/screens/main/mainScreen.dart';
import 'package:care_sync/src/theme/darkTheme.dart';
import 'package:care_sync/src/theme/lightTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/bloc/blockProvider.dart';
import 'src/bloc/userBloc.dart';
import 'src/models/user/userState.dart';

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
    return BlocListener<UserBloc, UserState>(
      listenWhen: (previous, current) =>
          previous.isLoggedIn && !current.isLoggedIn, // only when logging out
      listener: (context, state) {
        // Force navigation to login screen on logout
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CareSync',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: const AppEntry(),
      ),
    );
  }
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return context.read<UserBloc>().state.isLoggedIn? 
           const MainScreen()
           :const LoginScreen();
  }
}
