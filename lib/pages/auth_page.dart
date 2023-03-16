import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_login/pages/login_page.dart';
import 'package:modern_login/pages/main_page.dart';
import 'package:modern_login/pages/my_home_page.dart';
import 'login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return MainPage();
          }else{
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}