import 'dart:io';

import 'package:anonymous_chat/services/config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../screens/home.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: Config.supabaseUrl, anonKey: Config.supabaseAnon);
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    doWhenWindowReady(() {
      final win = appWindow;
      win.minSize = Size(200, 200);
      win.size = Size(800, 600);
      win.alignment = Alignment.center;
      win.show();
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'முடிவிலி',
      home: Home(),
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
          textTheme: TextTheme(
            displayLarge: TextStyle(fontFamily: 'lexend'),
            displayMedium: TextStyle(fontFamily: 'lexend'),
            displaySmall: TextStyle(fontFamily: 'lexend'),
            headlineLarge: TextStyle(fontFamily: 'lexend'),
            headlineMedium: TextStyle(fontFamily: 'lexend'),
            headlineSmall: TextStyle(fontFamily: 'lexend'),
            titleLarge: TextStyle(fontFamily: 'lexend'),
            titleMedium: TextStyle(fontFamily: 'lexend'),
            titleSmall: TextStyle(fontFamily: 'lexend'),
            bodyLarge: TextStyle(fontFamily: 'lexend'),
            bodyMedium: TextStyle(fontFamily: 'lexend'),
            bodySmall: TextStyle(fontFamily: 'lexend'),
            labelLarge: TextStyle(fontFamily: 'lexend'),
            labelMedium: TextStyle(fontFamily: 'lexend'),
            labelSmall: TextStyle(fontFamily: 'lexend'),
          ),
          iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                  shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
                  backgroundColor:
                      WidgetStatePropertyAll(const Color(0xFF478E7E)),
                  foregroundColor: WidgetStatePropertyAll(Colors.white))),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
                  backgroundColor:
                      WidgetStatePropertyAll(const Color(0xFF478E7E)),
                  foregroundColor: WidgetStatePropertyAll(Colors.white)))),
    );
  }
}
