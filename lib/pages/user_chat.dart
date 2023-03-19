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
 List<QueryDocumentSnapshot> _messages = [];
  TextEditingController messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _listenToChatMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<DocumentSnapshot> getUserDetails(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<void> sendMessage() async {
  if (messageController.text.isNotEmpty) {
    String message = messageController.text.trim();
    messageController.clear();

    

    // Add the message with a local timestamp
    DocumentReference docRef = await FirebaseFirestore.instance.collection('chats').add({
      'senderUid': widget.currentUserUid,
      'receiverUid': widget.chatUserUid,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _scrollToBottom();
  }
}


  void _scrollToBottom() {
  if (_scrollController.hasClients) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }
}

  void _listenToChatMessages() {
  getChatMessages().listen((newMessages) {
    if (mounted) { // Check if the widget is still mounted
      setState(() {
        _messages = newMessages;
      });
      _scrollToBottom();
    }
  });
}

 Stream<List<QueryDocumentSnapshot>> getChatMessages() {
  return FirebaseFirestore.instance
      .collection('chats')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {
        List<QueryDocumentSnapshot> docs = snapshot.docs;
        docs = docs.where((doc) {
          bool isCurrentUser = doc['senderUid'] == widget.currentUserUid;
          bool isChatUser = doc['senderUid'] == widget.chatUserUid;
          bool isRelevant = (isCurrentUser || isChatUser) &&
              (doc['receiverUid'] == widget.currentUserUid ||
                  doc['receiverUid'] == widget.chatUserUid);
          return isRelevant;
        }).toList();
        return docs;
      });
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
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                QueryDocumentSnapshot chatMessage = _messages[index];
                bool isSentByCurrentUser = chatMessage['senderUid'] == widget.currentUserUid;

                return Align(
                  alignment: isSentByCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
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
                        ),Text(
  chatMessage['timestamp'] != null && chatMessage['timestamp'] is Timestamp
      ? chatMessage['timestamp'].toDate().toString()
      : 'Pending...',
  style: TextStyle(
    fontSize: 12.0,
    color: isSentByCurrentUser
        ? Colors.white.withOpacity(0.7)
        : Colors.black.withOpacity(0.7),
  ),
),

                      ],
                    ),
                  ),
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

