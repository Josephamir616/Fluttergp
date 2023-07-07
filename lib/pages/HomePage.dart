// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:untitled/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/pages/creditcardinfo.dart';
import 'package:untitled/pages/login_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  bool is500 = false;

  List<Product> products = [];
  String name = "";
  int price = 0;
  int total_price = 0;
  String? username;

  Future<void> nextpage() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentPage(total_price: total_price,)),
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
    showDialog(
      context: context,
      builder: (context) {
        return const Center (
          child: CircularProgressIndicator(),
        );
      },
    );
    if (pickedImage != null) {
      File image = File(pickedImage.path);
      Map<String, dynamic> responseData = await uploadImage(image);
      if (!is500) {
        name = responseData['name'];
        price = responseData['price'];
      }
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(is500 ? "Product can not be detected, try to capture another photo." :'$name $price L.E') ,
            content: Image.file(File(pickedImage.path)),
            actions: [
              if (!is500) Text("Add to cart?"),
              if (!is500) TextButton(onPressed: () {
                Product product = Product(name: name, price: price,quantity: 1);
                setState(() {
                  products.add(product);
                  total_price += product.price;
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
    showDialog(
      context: context,
      builder: (context) {
        return const Center (
          child: CircularProgressIndicator(),
        );
      },
    );
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      Map<String, dynamic> responseData = await uploadImage(imageFile);
      if (!is500) {
        name = responseData['name'];
        price = responseData['price'];
      }
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(is500 ? "Product can not be detected, try to capture another photo." :'$name $price L.E'),
            content: Image.file(File(pickedImage.path)),
            actions: [
              if (!is500) Text("Add to cart?"),
              if (!is500) TextButton(onPressed: () {
                Product product = Product(name: name, price: price,quantity: 1);
                setState(() {
                  products.add(product);
                  total_price += product.price;
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
        centerTitle: true,
        title: const Text('Grab and Go'),
      ),
      body: products.length > 0 ? ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding:EdgeInsets.only(top: 10,left: 10,right: 10),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20),
              shadowColor: Colors.blueGrey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(product.name,style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text('Price: ${product.total_price} Quantity: ${product.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            total_price -= products[index].price;
                            products[index].quantity -= 1;
                            if (products[index].quantity==0) {
                              products.removeAt(index);
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            total_price += products[index].price;
                            products[index].quantity += 1;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ):Center(
        child: Text("Hello $username, start shopping now!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      ),
      bottomNavigationBar: Visibility(
        visible: products.isNotEmpty,
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Total price: $total_price",style: TextStyle(fontWeight: FontWeight.bold),),
              Row(
                children: [
                  SizedBox(
                    width: 185,
                    child: ElevatedButton(style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                      child: new Text("Delete Cart"),
                      onPressed: (){
                      setState(() {
                        products.clear();
                        total_price = 0;
                      });
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    width: 185,
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openCamera();
          /*
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
          );*/
        },
        child: const Icon(Icons.camera_alt_outlined),
        backgroundColor: Colors.black,
      ),
    );
  }
}
