import 'package:bee_bot/Pages/HomePage.dart';
import 'package:bee_bot/Pages/UserPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return const UserPage();
          }

          // user is not logged in
          else {
            return const HomePage();
          }
        },
      ),
    );
  }
}
