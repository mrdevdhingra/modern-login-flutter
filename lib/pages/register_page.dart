import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_login/components/my_button.dart';
import 'package:modern_login/components/my_textfield.dart';
import 'package:modern_login/components/square_tile.dart';
import 'package:modern_login/services/auth_services.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  //Sign userup method
  void signUserUp() async {

      //show loading
      showDialog(
        context: context, builder:(context) {
          return Center(
            child: CircularProgressIndicator(),
          ); 
        }
        );


      if(passwordController.text != confirmPasswordController.text){
        Navigator.pop(context);
        //if different pass
        showErrorMessage('Passwords don\'t match!');
        return;
      }

    //sign up
    try{
      //if password match
      
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text
      );
      
      Navigator.pop(context);
    } on FirebaseAuthException catch(e){
      Navigator.pop(context);
      showErrorMessage(e.code);
    } 
  }

    //ERROR MESSAGE
    void showErrorMessage(String message){
      showDialog(
        context: context,
         builder: (context){
          return  AlertDialog(
            title: Text(message),
          );
         }
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
          
                const SizedBox(height: 25,),
          
                //welcome message
                Text(
                  'Create your DeTechly account!',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16  ),
                  
                ),
          
                const SizedBox(height: 25,),
                
                //username or email
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
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

                //conffirm password

                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
          
                ),
          
          
                const SizedBox(height: 25,),
                
                //sign in buttom
                MyButton(
                  onTap: signUserUp,
                  text: 'Sign Up'
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
                    SquareTile(imagePath: 'lib/images/google-logo.png',onTap: () => AuthService().signInWithGoogle(),),
                    const SizedBox(width: 25,),
                    SquareTile(imagePath: 'lib/images/apple-logo.png',onTap: () {
                      
                    },)
                  ],
                ),
          
                const SizedBox(height: 25,),
                
                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text('Already a member?', style: TextStyle(color: Colors.grey[700]),),
                      SizedBox(width: 4,),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Login now',
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