import 'dart:io';

import 'package:bee_bot/Pages/AnswerPage.dart';
import 'package:bee_bot/Pages/BotPage.dart';
import 'package:bee_bot/models/image_model.dart';
import 'package:bee_bot/widgets/container_neo.dart';
import 'package:card_loading/card_loading.dart';

import 'package:bee_bot/widgets/shadowy_container.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void customDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          );
        });
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Fetch the document for the user
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();

      // Check if the document exists
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        print("User document does not exist.");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<String> fetchUsername() async {
    await Future.delayed(const Duration(seconds: 1));
    final FirebaseAuth auth = FirebaseAuth.instance;

    // Get the current user
    User? user = auth.currentUser;

    if (user != null) {
      // Fetch additional data from Firestore
      Map<String, dynamic>? userData = await getUserData(user.uid);

      if (userData != null) {
        // print("User Name: ${userData['name']}");
        return userData['name'];
      } else {
        return "User";
      }
    } else {
      return "User";
    }
  }

  Future _pickImageFrom(ImageSource source) async {
    final returnedImage = await ImagePicker().pickImage(source: source);

    if (returnedImage == null) {
      return;
    } else {
      Navigator.push(
          context,
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => BotPage(
                    question: File(returnedImage.path),
                  ))).then((value) {
        setState(() {});
      });
    }
  }

  final user = FirebaseAuth.instance.currentUser;
  final Box<ImageModel> imageBox = Hive.box<ImageModel>('images');

  @override
  Widget build(BuildContext context) {
    final userImages = imageBox.values
        .where((img) => img.userId == user?.uid)
        .toList()
        .reversed
        .toList(); // To display latest first
    Color backgroundColor = Colors.amber;

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        shadowColor: Colors.black,
        title: FutureBuilder(
          future: fetchUsername(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CardLoading(
                borderRadius: BorderRadius.circular(15),
                height: 75,
                width: 250,
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return ShadowyContainer(
                  text: "Hello ${snapshot.data}.",
                  width: 250,
                  bgcolor: const Color.fromARGB(255, 255, 255, 255));
            } else {
              return const Text('No data');
            }
          },
        ),
        actions: [
          DottedBorder(
            borderType: BorderType.Circle,
            borderPadding: const EdgeInsets.all(7),
            strokeWidth: 3,
            child: IconButton(
              icon: const Icon(Icons.logout),
              color: Colors.black,
              onPressed: signUserOut,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: userImages.isEmpty
          ? const Center(child: Text('No images added.'))
          : ListView.builder(
              itemCount: userImages.length,
              itemBuilder: (context, index) {
                final img = userImages[index];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Container_Neo(
                          onPressed: () {
                            print("Object ID is: ${img.key}");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnswerPage(
                                          objectId: img.key,
                                          image: File(img.imagePath),
                                          text: img.text,
                                        ))).then((value) => setState(() {}));
                          },
                          bgcolor: Colors.amber,
                          size: 35,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(35 / 5)),
                              child: Image.file(
                                File(img.imagePath),
                                fit: BoxFit.cover,
                              ))),
                    ),
                    // Visibility(child: ,visible: false,)
                  ],
                );
              },
            ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        openCloseStackAlignment: Alignment.center,
        distance: 70,
        type: ExpandableFabType.side,
        children: [
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.camera_enhance_rounded),
            onPressed: () {
              _pickImageFrom(ImageSource.camera);
            },
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.add_photo_alternate),
            onPressed: () {
              _pickImageFrom(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
