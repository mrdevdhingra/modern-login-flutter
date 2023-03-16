import 'package:flutter/material.dart';
import 'package:modern_login/pages/chat_page.dart';
import 'package:modern_login/pages/home_page.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          HomePage(
            pageController: _pageController,
          ),
          ChatPage(
            pageController: _pageController,
          ),
        ],
      ),
    );
  }
}