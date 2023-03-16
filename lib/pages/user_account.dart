import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAccount extends StatefulWidget {
  UserAccount({Key? key}) : super(key: key);

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  final user = FirebaseAuth.instance.currentUser!;
  String? firstName;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    final documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (documentSnapshot.exists) {
      setState(() {
        firstName = documentSnapshot.get('first name');
      });
    } else {
      print('Document does not exist');
    }
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FirebaseAuth.instance.currentUser!.email!),
      ),
      body:firstName == null
          ? Center(child: CircularProgressIndicator())
          : Center(child: Text(firstName!)),
      floatingActionButton: FloatingActionButton(
        onPressed: signUserOut,
        child: const Icon(Icons.logout),
      ),
    );
  }
}
