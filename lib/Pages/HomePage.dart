import 'package:bee_bot/Pages/PasswordForgot.dart';
import 'package:bee_bot/Pages/SignUpPage.dart';
import 'package:bee_bot/Pages/UserPage.dart';
import 'package:bee_bot/widgets/button_neo.dart';
import 'package:bee_bot/widgets/incorrect_message.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:bee_bot/widgets/input_field.dart';
import 'package:bee_bot/widgets/shadowy_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // controllers for input fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // input field background color
  Color emailInputColor = Colors.white;
  Color passwordInputColor = Colors.white;
  Color alertColor = const Color.fromARGB(255, 255, 38, 38);

  String message = "";
  bool errorVisible = false;

  void signUserIn() async {
    // show a loading circle
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return Center(
    //       child: LoadingAnimationWidget.staggeredDotsWave(
    //         color: const Color.fromARGB(255, 255, 225, 0),
    //         size: 50,
    //       ),
    //     );
    //   },
    // );

    try {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        message = "Please fill in all fields!";
        errorVisible = true;
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
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        setState(() {
          message = "Incorrect password!";
          _passwordController.clear();
          errorVisible = true;
        });
      } else if (e.code == 'user-not-found') {
        setState(() {
          message = "Incorrect e-mail!";
          _passwordController.clear();
          errorVisible = true;
        });
      } else {
        setState(() {
          message = "Incorrect e-mail!";
          _passwordController.clear();
          errorVisible = true;
        });
      }
    } catch (e) {
      setState(() {
        message = "Incorrect e-mail!";
        _passwordController.clear();
        errorVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    const bgcolor = Color.fromRGBO(167, 166, 255, 0.677);
    const signInColor = Color.fromRGBO(185, 255, 159, 1);
    return Scaffold(
      backgroundColor: bgcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const ShadowyContainer(
                text: "Sign In", width: 200, bgcolor: signInColor),
            const SizedBox(height: 30),
            InputField(
              hintText: "E-mail",
              obscureText: false,
              controller: _emailController,
              bgcolor: emailInputColor,
            ),
            const SizedBox(height: 20),
            InputField(
              hintText: "Password",
              bgcolor: passwordInputColor,
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 15),
            Visibility(
              visible: !errorVisible,
              child: const SizedBox(height: 30),
            ),
            Visibility(
              visible: errorVisible,
              child: DottedBorder(
                strokeWidth: 2,
                padding: const EdgeInsets.all(6),
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                child: Text(
                  message,
                  style: TextStyle(
                      color: alertColor,
                      fontFamily: 'IBMPlex',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonNeo(
                  bgcolor: const Color.fromARGB(255, 93, 218, 31),
                  text: "Log in",
                  onPressed: () {
                    signUserIn();
                  },
                ),
                const SizedBox(width: 20),
                ButtonNeo(
                  bgcolor: const Color.fromARGB(255, 93, 218, 31),
                  text: "Sign Up",
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const SignUpPage(),
                        // transitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
            ButtonNeo(
                bgcolor: Colors.red[300]!,
                text: "Forgot Password?",
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const PasswordForgot(),
                      transitionDuration: Duration.zero,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
