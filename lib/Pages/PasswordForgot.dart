import 'package:bee_bot/widgets/button_neo.dart';
import 'package:bee_bot/widgets/input_field.dart';
import 'package:bee_bot/widgets/shadowy_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordForgot extends StatefulWidget {
  const PasswordForgot({super.key});

  @override
  State<PasswordForgot> createState() => _PasswordForgotState();
}

class _PasswordForgotState extends State<PasswordForgot> {
  TextEditingController emailController = TextEditingController();

  Future<void> sendPasswordResetEmail() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an e-mail address'),
          backgroundColor: Colors.red,
          elevation: 10,
        ),
      );
      return;
    }
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent'),
          backgroundColor: Colors.green,
          elevation: 10,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail not found'),
          elevation: 10,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    const bgcolor = Color.fromRGBO(167, 166, 255, 0.677);
    return Scaffold(
      backgroundColor: bgcolor,
      body: Center(
        child: Container(
          height: 400,
          width: 320,
          decoration: BoxDecoration(
            color: const Color.fromARGB(
                255, 52, 170, 255), // Light green background
            border: Border.all(color: Colors.black, width: 2), // Black border
            boxShadow: const [
              BoxShadow(
                color: Colors.black, // Shadow color
                offset: Offset(4, 4), // Shadow offset
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ShadowyContainer(
                    text: "Reset Your Password",
                    width: 250,
                    bgcolor: Color.fromARGB(255, 247, 34, 34)),
                const SizedBox(height: 40),
                InputField(
                  hintText: "E-mail address",
                  obscureText: false,
                  bgcolor: Colors.white,
                  controller: emailController,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonNeo(
                        bgcolor: bgcolor,
                        text: "Cancel",
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    const SizedBox(width: 20),
                    ButtonNeo(
                        bgcolor: bgcolor,
                        text: "Continue",
                        onPressed: () {
                          sendPasswordResetEmail();
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
