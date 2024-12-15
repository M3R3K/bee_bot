import 'package:bee_bot/Pages/UserPage.dart';
import 'package:bee_bot/widgets/button_neo.dart';
import 'package:bee_bot/widgets/input_field.dart';
import 'package:bee_bot/widgets/shadowy_container.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Color nameInputColor = Colors.white;
  Color emailInputColor = Colors.white;
  Color passwordInputColor = Colors.white;
  Color alertColor = const Color.fromARGB(255, 255, 38, 38);
  String message = "";
  bool errorVisible = false;

  Future<void> _register() async {
    if (_nameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _emailController.text.isEmpty) {
      message = "Please fill in all fields!";
      errorVisible = true;
      if (_nameController.text.isEmpty) {
        setState(() {
          nameInputColor = alertColor;
        });
      }
      if (_emailController.text.isEmpty) {
        setState(() {
          emailInputColor = alertColor;
        });
      }
      if (_passwordController.text.isEmpty) {
        setState(() {
          passwordInputColor = alertColor;
        });
      }
      return;
    }

    // show a loading circle
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: const Color.fromARGB(255, 255, 225, 0),
            size: 50,
          ),
        );
      },
    );

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _nameController.text,
          'email': user.email,
        });
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          passwordInputColor = alertColor;
          message = "The password provided is too weak.";
          errorVisible = true;
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          emailInputColor = alertColor;
          message = "The account already exists for that email.";
          errorVisible = true;
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          emailInputColor = alertColor;
          message = "The email address is badly formatted.";
          errorVisible = true;
        });
      }
    } catch (e) {
      print(e);
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      body: Center(
        child: Container(
          height: 500,
          width: 320,
          decoration: BoxDecoration(
            color: Colors.purple[200], // Light green background
            border: Border.all(color: Colors.black, width: 2), // Black border
            boxShadow: const [
              BoxShadow(
                color: Colors.black, // Shadow color
                offset: Offset(4, 4), // Shadow offset
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const ShadowyContainer(
                  text: "Sign Up!", width: 250, bgcolor: Colors.white),
              SizedBox(height: 45),
              InputField(
                hintText: "Name",
                obscureText: false,
                controller: _nameController,
                bgcolor: nameInputColor,
              ),
              SizedBox(height: 20),
              InputField(
                  hintText: "E-mail",
                  obscureText: false,
                  controller: _emailController,
                  bgcolor: emailInputColor),
              SizedBox(height: 20),
              InputField(
                hintText: "Password",
                obscureText: true,
                controller: _passwordController,
                bgcolor: passwordInputColor,
              ),
              SizedBox(height: 15),
              Visibility(child: SizedBox(height: 30), visible: !errorVisible),
              Visibility(
                visible: errorVisible,
                child: DottedBorder(
                  padding: EdgeInsets.all(6),
                  strokeWidth: 2,
                  child: Text(
                    message,
                    style: TextStyle(color: alertColor, fontFamily: "IBMPlex"),
                  ),
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonNeo(
                    text: "Cancel",
                    bgcolor: Color.fromRGBO(255, 243, 243, 1),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 20),
                  ButtonNeo(
                    text: "Sign Up!",
                    bgcolor: Color.fromRGBO(255, 243, 243, 1),
                    onPressed: () {
                      _register();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
