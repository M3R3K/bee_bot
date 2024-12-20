import 'package:bee_bot/widgets/container_neo.dart';
import 'package:flutter/material.dart';

class TestingPage extends StatefulWidget {
  const TestingPage({super.key});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testing"),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container_Neo(
            bgcolor: Colors.amber,
            size: 35,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(35 / 5)),
                child: Image.asset(
                  'images/question.png',
                  fit: BoxFit.cover,
                ))),
      ),
    );
  }
}
