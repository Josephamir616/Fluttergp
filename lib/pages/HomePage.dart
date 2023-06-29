// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:untitled/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/pages/creditcardinfo.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  bool is500 = false;

  List<Product> products = [];
  String name = "";
  String price = "";
  int total_price = 0;
  String? username;

  Future<void> nextpage() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentPage()),
    );
  }
  Future<String?> getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    return token;
  }

  void decodeToken() async {
    // Retrieve the token from SharedPreferences
    String? token = await getTokenFromSharedPreferences();

    if (token != null) {
      // Decode the token
      Map<String, dynamic>? decodedToken = Jwt.parseJwt(token);

      // Access the token claims
      setState(() {
        username = decodedToken?['username'];
      });
      // Use the decoded token claims as needed
      print('Username: $username');
    } else {
      // Token not found in SharedPreferences
      print('Token not found');
    }
  }


  @override
  void initState() {
    setState(() {
      decodeToken();
    });
  }

  Future<Map<String, dynamic>> uploadImage(File image) async {
    is500 = false;
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path, filename: 'image.jpg'),
    });

    try {
      Response response = await dio.post('http://10.0.2.2:5000/predictImg', data: formData);
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        print(response.data);
        return response.data;
      } else {
        is500 = true;
        print('Failed to upload image. StatusCode: ${response.statusCode}');
      }
    } catch (error) {
      is500 = true;
      // Handle any exceptions during the request
      print('Error uploading image: $error');
    }

    return {};
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      File image = File(pickedImage.path);
      Map<String, dynamic> responseData = await uploadImage(image);
      if (!is500) {
        name = responseData['name'];
        price = responseData['price'].toString();
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(is500 ? "Product can not be detected, try to capture another photo." :'$name $price L.E') ,
            content: Image.file(File(pickedImage.path)),
            actions: [
              if (!is500) Text("Add to cart?"),
              if (!is500) TextButton(onPressed: () {
                Product product = Product(name: name, price: price);
                setState(() {
                  products.add(product);
                  total_price += int.parse(product.price);
                });
                Navigator.of(context).pop();
              }, child: Text("Yes")),
              if (!is500) TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text("No")),
              if (is500)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
            ],
          );
        },
      );
    }
  }

  void pickFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      Map<String, dynamic> responseData = await uploadImage(imageFile);
      if (!is500) {
        name = responseData['name'];
        price = responseData['price'].toString();
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(is500 ? "Product can not be detected, try to capture another photo." :'$name $price L.E'),
            content: Image.file(File(pickedImage.path)),
            actions: [
              if (!is500) Text("Add to cart?"),
              if (!is500) TextButton(onPressed: () {
                Product product = Product(name: name, price: price);
                setState(() {
                  products.add(product);
                  total_price += int.parse(product.price);
                });
                Navigator.of(context).pop();
              }, child: Text("Yes")),
              if (!is500) TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text("No")),
              if (is500)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey,
        title: const Text('Grab and Go'),
      ),
      body: products.length > 0 ? ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Material(
            elevation: 15.0,
            shadowColor: Colors.blueGrey,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child:  ListTile(
                title: Text(product.name),
                subtitle: Text('Price: ${product.price}'),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    setState(() {
                      products.removeAt(index);
                    });
                  },
                ),
              ),
            ),
          );
        },
      ):Center(
        child: Text("Hello $username, start shopping now!"),
      ),
      bottomNavigationBar: Visibility(
        visible: products.isNotEmpty,
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              SizedBox(
                width: 140,
                child: ElevatedButton(style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                  child: new Text("Remove all products"),
                  onPressed: (){
                  setState(() {
                    products.clear();
                  });
                  },
                ),
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: 140,
                child: ElevatedButton(style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                  child: new Text("Proceed to Checkout"),
                  onPressed: (){
                  nextpage();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
                      openCamera();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Pick from Gallery'),
                    onTap: () {
                      pickFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}
