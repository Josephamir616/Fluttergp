import 'package:flutter/material.dart';
import 'package:untitled/components/my_button.dart';
import 'package:untitled/components/my_button2.dart';
import 'package:untitled/components/my_textfield.dart';
import 'package:untitled/components/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final phonenumbercontroller = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserup(){}

  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  //logo
                  const Icon(Icons.lock, size: 100,),
                  //Welcome back
                  const SizedBox(height: 50),
                  Text('Welcome back you\'ve been missed!',style: TextStyle(fontSize: 16,),
                  ),
                  const SizedBox(height: 30),
                  //username textfield
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  //password textfield
                  MyTextField(
                    controller: phonenumbercontroller,
                    hintText: 'Mobile Number',
                    obscureText: false,
                  ),
                  const SizedBox(height : 10),
                  //Confirm password
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height : 10),
                  //forgot password?
                  const SizedBox(height: 25),
                  //sign in button
                  MyButton2(
                    onTap: signUserup,
                  ),
                  const SizedBox(height: 30),
                  //or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Or continue with',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  //google + apple sign in buttons
                  const SizedBox(height: 20),
                  //not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?'),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Login now',
                          style: TextStyle (
                              color: Colors.blue, fontWeight: FontWeight.bold ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
