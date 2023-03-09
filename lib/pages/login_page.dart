import 'package:flutter/material.dart';
import 'package:modern_login/components/my_button.dart';
import 'package:modern_login/components/my_textfield.dart';
import 'package:modern_login/components/square_tile.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //text editing controllers

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //Sign userin method
  void signUserIn(){}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center( 
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
                controller: usernameController,
                hintText: 'Username',
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
                  SquareTile(imagePath: 'lib/images/google-logo.png'),
                  const SizedBox(width: 25,),
                  SquareTile(imagePath: 'lib/images/apple-logo.png')
                ],
              ),

              const SizedBox(height: 25,),
              
              //not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text('Not a member?', style: TextStyle(color: Colors.grey[700]),),
                    SizedBox(width: 4,),
                    Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}