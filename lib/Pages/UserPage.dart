import 'package:bee_bot/widgets/button_neo.dart';
import 'package:bee_bot/widgets/shadowy_container.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // @override
  // void initState()  async{
  //   super.initState();
  //   // fetchUsername();
  //   String username = await fetchUsername();
  // }

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          shadowColor: Colors.black,
          title: FutureBuilder(
            future: fetchUsername(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // return Text('Hello ${snapshot.data}.');
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
                onPressed: signUserOut,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset('images/question.png', fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ));
  }
}
