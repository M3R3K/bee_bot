import 'package:bee_bot/Pages/AuthPage.dart';
import 'package:bee_bot/Pages/UserPage.dart';
import 'package:bee_bot/models/image_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bee_bot/api_key.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bee_bot/firebase_options.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter(); // Initializes Hive with default Flutter directory
  Hive.registerAdapter(ImageModelAdapter());
  await Hive.openBox<ImageModel>('images');
  runApp(const MyApp());

  runApp(const MyApp());
}

getApplicationDocumentsDirectory() {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: AuthPage(),
        ));
  }
}
