import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class UserChat extends StatefulWidget {
  final String currentUserUid;
  final String chatUserUid;

  UserChat({required this.currentUserUid, required this.chatUserUid});

  @override
  _UserChatState createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<QueryDocumentSnapshot> _messages = [];
  ScrollController _scrollController = ScrollController();

  TextEditingController messageController = TextEditingController();

  Future<DocumentSnapshot> getUserDetails(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<void> sendMessage() async {
    if (messageController.text.isNotEmpty) {
      String message = messageController.text.trim();
      messageController.clear();

      await FirebaseFirestore.instance.collection('chats').add({
        'senderUid': widget.currentUserUid,
        'receiverUid': widget.chatUserUid,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _scrollToBottom();
    }
  }

 Stream<List<QueryDocumentSnapshot>> getChatMessages() {
  Stream<QuerySnapshot> streamA = FirebaseFirestore.instance
      .collection('chats')
      .where('senderUid', isEqualTo: widget.currentUserUid)
      .where('receiverUid', isEqualTo: widget.chatUserUid)
      .snapshots();

  Stream<QuerySnapshot> streamB = FirebaseFirestore.instance
      .collection('chats')
      .where('senderUid', isEqualTo: widget.chatUserUid)
      .where('receiverUid', isEqualTo: widget.currentUserUid)
      .snapshots();

  return Rx.combineLatest2<QuerySnapshot, QuerySnapshot, List<QueryDocumentSnapshot>>(
    streamA,
    streamB,
    (a, b) {
      List<QueryDocumentSnapshot> allDocs = [
        ...a.docs,
        ...b.docs,
      ];

      allDocs.sort((doc1, doc2) {
        Timestamp time1 = doc1['timestamp'];
        Timestamp time2 = doc2['timestamp'];
        return time1.compareTo(time2);
      });

      return allDocs;
    },
  );
}

void _scrollToBottom() {
  if (_scrollController.hasClients) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: getUserDetails(widget.chatUserUid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        String chatUserUsername = snapshot.data!['username'];

        return Scaffold(
          appBar: AppBar(
            title: Text(chatUserUsername),
          ),
          body: Column(
            children: [
             Expanded(
          child: StreamBuilder<List<QueryDocumentSnapshot>>(
            stream: getChatMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.isEmpty) {
                return Center(child: Text('No messages yet.'));
              }

              _messages = snapshot.data!;

               

              return ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot chatMessage = _messages[index];
                  bool isSentByCurrentUser = chatMessage['senderUid'] == widget.currentUserUid;
                  

                  return Align(
                    alignment:
                        isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: isSentByCurrentUser ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chatMessage['message'],
                            style: TextStyle(
                              color: isSentByCurrentUser ? Colors.white : Colors.black,
                            ),
                          ),
                          FutureBuilder<Timestamp>(
              future: Future.value(chatMessage['timestamp']),
              builder: (BuildContext context, AsyncSnapshot<Timestamp> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('');
                } else {
                  return Text(
                    snapshot.data!.toDate().toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: isSentByCurrentUser
                          ? Colors.white.withOpacity(0.7)
                          : Colors.black.withOpacity(0.7),
                    ),
                  );
                }
              },
            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),




              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: sendMessage,
                                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

