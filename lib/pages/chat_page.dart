import 'package:flutter/material.dart';
import 'package:modern_login/pages/home_page.dart';

import 'chat_system.dart';

class ChatPage extends StatelessWidget {
  final PageController pageController;

  const ChatPage({Key? key, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            pageController.animateToPage(
              0,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
      body: ChatSystem(),
    );
  }
}