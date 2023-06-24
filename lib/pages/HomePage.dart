import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';


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
        child: Text("No items yet")
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          retrieveToken();
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Open Camera'),
                    onTap: () {
                      // Perform action for opening the camera
                      openCamera();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Pick from Gallery'),
                    onTap: () {
                      // Perform action for picking from the gallery
                      pickFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add), // Add your icon here
        backgroundColor: Colors.black, // Add your desired background color here
      ),// center
    );
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      // Handle the captured image
      // You can display it, upload it to a server, or perform any other required operations
      // The pickedImage.path provides the path to the captured image file
      print('Image path: ${pickedImage.path}');
    }
  }
  void pickFromGallery() {

  }

}
