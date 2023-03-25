import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return Center(child: Text('Please sign in to view friends'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friends')
          .snapshots(),
      builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return Center(child: CircularProgressIndicator());
           } else if (snapshot.hasError) {
             return Center(child: Text('Error: ${snapshot.error}'));
           } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
             return Center(child: Text('No friends added yet'));
           } else {
             return ListView.builder(
               itemCount: snapshot.data!.docs.length,
               itemBuilder: (context, index) {
                 final friend = snapshot.data!.docs[index].data() as Map<String, dynamic>?;
                 if (friend == null) {
                   return SizedBox.shrink(); // Skip rendering this item
                 }
                 return ListTile(
                   title: Text((friend['firstname'] ?? '') + ' ' + (friend['secondname'] ?? '')),
                   subtitle: Text(friend['email'] ?? ''),
                 );
               },
    );
  }
},

    );
      }
  }

     
