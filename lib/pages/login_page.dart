import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_login/components/my_button.dart';
import 'package:modern_login/components/my_textfield.dart';
import 'package:modern_login/components/square_tile.dart';
import 'package:modern_login/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controllers
  final emailOrUsernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Get email from username
  Future<String?> getEmailFromUsername(String username) async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      return userSnapshot.docs.first.get('email');
    } else {
      return null;
    }
  }

  // Sign user in method
  void signUserIn() async {
    // Show loading
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    String? email = emailOrUsernameController.text;

    if (!email.contains('@')) {
      // If the entered value is a username, get the associated email
      email = await getEmailFromUsername(emailOrUsernameController.text);
      if (email == null) {
        Navigator.pop(context);
        showErrorMessage('Username not found');
        return;
      }
    }

    // Sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  // ERROR MESSAGE
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center( 
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
          
                const SizedBox(height: 40),
          
                //logo
                Image.asset(
                  'lib/images/detechly.png',
                  height: 50,
                ),
          
                const SizedBox(height: 50,),
          
                //welcome message
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16  ),
                  
                ),
          
                const SizedBox(height: 50,),
                
                //username or email
                MyTextField(
                  controller: emailOrUsernameController,
                  hintText: 'Email or username',
                  obscureText: false,
          
                ),
          
                const SizedBox(height: 10,),
                
                
                //passowrd
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
          
                ),
          
                const SizedBox(height: 10,),
          
                
                //forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
          
                const SizedBox(height: 25,),
                
                //sign in buttom
                MyButton(
                  onTap: signUserIn,
                  text: 'Log In',
                ),
          
                const SizedBox(height: 50,),
          
                
                //or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),  
                      ),
                
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50,),
                
                //google+apple sign in
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(imagePath: 'lib/images/google-logo.png', onTap: () => AuthService().signInWithGoogle(),),
                    const SizedBox(width: 25,),
                    SquareTile(imagePath: 'lib/images/apple-logo.png', onTap: () {},)
                  ],
                ),
          
                const SizedBox(height: 25,),
                
                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text('Not a member?', style: TextStyle(color: Colors.grey[700]),),
                      SizedBox(width: 4,),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}