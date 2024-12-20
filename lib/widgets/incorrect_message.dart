import 'package:flutter/material.dart';

class IncorrectMessage extends StatefulWidget {
  const IncorrectMessage({super.key, required this.onlyPasswordError});
  final bool? onlyPasswordError;

  @override
  State<IncorrectMessage> createState() => _IncorrectMessageState();
}

class _IncorrectMessageState extends State<IncorrectMessage> {
  String messageFunction(onlyPasswordError) {
    if (onlyPasswordError == null) {
      return "";
    } else if (onlyPasswordError) {
      return "Incorrect password!";
    } else {
      return "Incorrect e-mail!";
    }
  }

  @override
  Widget build(BuildContext context) {
    String message = messageFunction(widget.onlyPasswordError);
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
