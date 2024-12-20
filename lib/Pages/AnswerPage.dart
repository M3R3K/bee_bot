import 'dart:io';

import 'package:bee_bot/models/image_model.dart';
import 'package:bee_bot/widgets/button_neo.dart';
import 'package:bee_bot/widgets/shadowy_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AnswerPage extends StatefulWidget {
  const AnswerPage(
      {required this.text,
      required this.image,
      required this.objectId,
      super.key});
  final String text;
  final File image;
  final int objectId;

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  final Box<ImageModel> imageBox = Hive.box<ImageModel>('images');

  Future<void> _removeImage(objectId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    imageBox.delete(objectId);
  }

  @override
  Widget build(BuildContext context) {
    Color bgcolor = Color.fromRGBO(244, 216, 56, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Answer"),
        elevation: 15,
        backgroundColor: bgcolor,
      ),
      backgroundColor: const Color.fromRGBO(10, 94, 178, 1),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: ListView(
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                clipBehavior: Clip.antiAlias,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      color: bgcolor,
                    ),
                    child: Image.file(widget.image))),
            const SizedBox(height: 15),
            ShadowyContainer(
                text: "Bee bot answer", width: 250, bgcolor: bgcolor),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ShadowyContainer(
                  text: widget.text,
                  width: 250,
                  bgcolor: const Color.fromARGB(255, 255, 255, 255)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonNeo(
                    bgcolor: Colors.red,
                    text: "Delete this answer",
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  color: bgcolor,
                                ),
                                width: 250,
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const ShadowyContainer(
                                        text: "Are you sure?",
                                        width: 200,
                                        bgcolor:
                                            Color.fromRGBO(255, 131, 131, 1)),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ButtonNeo(
                                            bgcolor: Colors.green,
                                            text: "Yes",
                                            onPressed: () {
                                              _removeImage(widget.objectId);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            }),
                                        const SizedBox(width: 20),
                                        ButtonNeo(
                                            bgcolor: Colors.red,
                                            text: "No",
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    }),
              ],
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
