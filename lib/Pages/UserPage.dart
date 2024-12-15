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
          shadowColor: Colors.black,
          title: FutureBuilder(
            future: fetchUsername(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Text('Hello ${snapshot.data}.');
              } else {
                return const Text('No data');
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: signUserOut,
            ),
          ],
        ),
        body: Column(
          children: [],
        ));
  }
}
