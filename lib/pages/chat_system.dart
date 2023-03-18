import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_login/pages/user_chat.dart';

class ChatSystem extends StatefulWidget {
  @override
  _ChatSystemState createState() => _ChatSystemState();
}

class _ChatSystemState extends State<ChatSystem> {
  final TextEditingController _searchController = TextEditingController();
  String? _searchString;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchString = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Search by username',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: (_searchString == null || _searchString!.trim() == '')
                ? FirebaseFirestore.instance.collection('users').snapshots()
                : FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: _searchString!.trim())
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final users = snapshot.data!.docs;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  if (user.id == _auth.currentUser!.uid) {
                    return SizedBox.shrink();
                  }
                  return ListTile(
                    title: Text(user['username']),
                    onTap: () {
                      // Open chat with the selected user
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                           builder: (context) => UserChat(
                             currentUserUid: FirebaseAuth.instance.currentUser!.uid,
                             chatUserUid: user.id,
                            ),
                        ),
                      );

                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
