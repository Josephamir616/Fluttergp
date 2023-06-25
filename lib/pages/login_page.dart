import 'package:flutter/material.dart';
import 'package:untitled/components/my_button.dart';
import 'package:untitled/components/my_textfield.dart';
import 'package:untitled/components/square_tile.dart';
import 'package:dio/dio.dart';
import 'package:untitled/pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  // sign user in method
  // sign user in method
  Dio dio = Dio();
  // sign user in method
  Future<void> sendPostRequest() async {
    try {
      var response = await dio.post(
        'http://10.0.2.2:5000/login',
        data: {
          "username":usernameController.text,
          "password":passwordController.text,
        },
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      // Process the response
      print(response.data);
      String token = response.data['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);


    } catch (e) {
      // Handle any errors
      print('Error: $e');
    }
  }

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
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height : 10),
                //forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Forgot Password?',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                //sign in button
                MyButton(
                  onTap: sendPostRequest,
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
                    Text('Not a member?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register now',
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
