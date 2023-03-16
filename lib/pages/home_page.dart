import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_login/pages/chat_page.dart';

class HomePage extends StatelessWidget {
  final PageController pageController;

   HomePage({Key? key, required this.pageController}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  //signout
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('lib/images/detechly.png',height: 35,),
            
          ],
        ),
        
        actions: [
          IconButton(
              onPressed: () {
                pageController.animateToPage(
                  1,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              icon: Icon(Icons.messenger_outline_outlined))
        ],
      ),
      body: Center(
        child: Text(
          'lOGGED IN' + user.email!,
          style: TextStyle(fontSize: 20),
        ),
      ),
      
    );
  }
}