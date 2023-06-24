import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  @override
  State<HomePage> createState()=>HomePageState();
}

class HomePageState extends State<HomePage> {
  @override

  void retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('Token: $token');
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey,
        title: const Text('Grab and Go'),
      ), //AppBar
      body: const Center(
        child: Text(
          'Scan product',
          style: TextStyle(fontSize: 24),
        ), //Text
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          retrieveToken();
        },
        child: Icon(Icons.add), // Add your icon here
        backgroundColor: Colors.blue, // Add your desired background color here
      ),// center
    );
  }

}
