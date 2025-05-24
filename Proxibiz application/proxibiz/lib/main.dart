import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:proxibiz/modules/contact.dart';
import 'package:proxibiz/modules/oublier.dart';
import 'package:proxibiz/modules/splash_screen.dart';

// Import uniquement si pas web
// ignore: avoid_web_libraries_in_flutter
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialiser sqflite_common_ffi uniquement sur desktop (Windows, Linux, macOS)
  if (!kIsWeb) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ProxiBiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        // '/itineraire': (context) => ItinerairePage()
        '/oublier': (context) => OublierMotDePasse(),
      },
      // Plus besoin de AccueilPage
    );
  }
}