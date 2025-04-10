import 'dart:io';
import 'package:bee_bot/widgets/button_neo.dart';
import 'package:bee_bot/widgets/shadowy_container.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive/hive.dart';
import '../models/image_model.dart';

class BotPage extends StatefulWidget {
  const BotPage({super.key, required this.question});

  final File question;
  @override
  State<BotPage> createState() => _BotPageState();
}

class _BotPageState extends State<BotPage> {
  final Box<ImageModel> imageBox = Hive.box<ImageModel>('images');

  Future<void> _addImage(File image, String text) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final imageModel = ImageModel(
      userId: user.uid,
      imagePath: image.path,
      text: text,
    );
    imageBox.add(imageModel);
  }

  Future<String?> getResponse(File question) async {
    const String API_KEY = String.fromEnvironment('API_KEY');
    print(API_KEY);
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: API_KEY);
    final imageByte = await question.readAsBytes();

    final prompt = TextPart(
        "Can you solve and explain this math problem for me? The image includes multiple choice questions, so please provide the answer and explanation with plain text with no markdown tags. Ignore every other question.");

    final imagePart = DataPart('image/jpeg', imageByte);

    // Fetch response using the pro model
    final response = await model.generateContent([
      Content.multi([prompt, imagePart])
    ]);

    return response.text?.replaceAll('*', '');
  }

  @override
  Widget build(BuildContext context) {
    Color bgcolor = const Color.fromRGBO(244, 216, 56, 1);

    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 40, 10, 10),
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              color: bgcolor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(widget.question),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 35),
            child: ShadowyContainer(
              text: "Bee Bot Answer",
              width: 150,
              bgcolor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                color: bgcolor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: FutureBuilder(
                  future: getResponse(widget.question),
                  builder:
                      (BuildContext context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CardLoading(
                        borderRadius: BorderRadius.circular(15),
                        height: 75,
                        width: 250,
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: ShadowyContainer(
                            text: snapshot.data ?? "No data",
                            width: 250,
                            bgcolor: const Color.fromARGB(255, 255, 255, 255)),
                      );
                    } else {
                      return const Text('No data');
                    }
                  },
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonNeo(
                  bgcolor: Colors.red,
                  text: "Cancel",
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              const SizedBox(width: 10),
              ButtonNeo(
                  bgcolor: Colors.green,
                  text: "Save answer.",
                  onPressed: () async {
                    await _addImage(widget.question,
                        "Answer: ${await getResponse(widget.question)}");
                    Navigator.pop(context);
                  }),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
