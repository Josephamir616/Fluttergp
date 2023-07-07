import 'package:flutter/material.dart';
import 'package:untitled/components/my_button.dart';
import 'package:untitled/components/my_button2.dart';
import 'package:untitled/components/my_textfield.dart';
import 'package:untitled/components/square_tile.dart';
import 'package:untitled/pages/LoginOrRegister.dart';
import 'package:dio/dio.dart';
import 'package:untitled/pages/login_page.dart';

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

  bool usernameEmpty = false;
  bool passwordEmpty = false;
  bool numberEmpty = false;

  // sign user in method
  Dio dio = Dio();
  // sign user in method
  Future<void> sendPostRequest() async {

    setState(() {
      usernameEmpty = usernameController.text.isEmpty;
      passwordEmpty = passwordController.text.isEmpty;
      numberEmpty = phonenumbercontroller.text.isEmpty;
    });

    if (!usernameEmpty && !passwordEmpty && !numberEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const Center (
            child: CircularProgressIndicator(),
          );
        },
      );
    }
    try {
      var response = await dio.post(
        'http://10.0.2.2:5000/register',
        data: {
          "username":usernameController.text,
          "password":passwordController.text,
          "number":phonenumbercontroller.text
        },
      );
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(onTap:(){})),
      );
      // Process the response
      print(response.data);
    } catch (e) {
      // Handle any errors
      if (!usernameEmpty && !passwordEmpty && !numberEmpty) {
        Navigator.pop(context);
      }
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/Images/grabngo.jpg',height: 100,),
                  //Welcome back
                  const SizedBox(height: 50),
                  Text('Welcome to Grab and Go Register Now!',style: TextStyle(fontSize: 16,),
                  ),
                  const SizedBox(height: 30),
                  //username textfield
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                    errorText: usernameEmpty ? 'Please enter a username':null
                  ),
                  const SizedBox(height: 15),
                  //password textfield
                  MyTextField(
                    errorText: numberEmpty ? 'Please enter a phone number' : null,
                    controller: phonenumbercontroller,
                    hintText: 'Mobile Number',
                    obscureText: false,
                  ),
                  const SizedBox(height : 15),
                  //Confirm password
                  MyTextField(
                    errorText: passwordEmpty ? 'Please enter a password': null,
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  SizedBox(height: 10,),
                  MyButton2(
                    onTap: sendPostRequest,
                  ),
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
