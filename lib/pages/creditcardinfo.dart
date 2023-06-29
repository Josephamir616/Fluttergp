import 'package:flutter/material.dart';
import 'package:untitled/pages/HomePage.dart';

class PaymentPage extends StatefulWidget {
  int total_price;
  PaymentPage({
   super.key,required this.total_price
});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Payment Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Text("Total price: ${widget.total_price} L.E",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    SizedBox(width: 60,),
                    Image.asset('lib/Images/visa.jpg',width: 150,height: 100,),
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[200], // Background color of the text field
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Cardholder name",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[200], // Background color of the text field
                  ),
                  child: TextField(
                    obscureText: true,
                    controller: _cardNumberController,
                    decoration: const InputDecoration(
                      labelText: "Card number",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[200], // Background color of the text field
                  ),
                  child: TextField(
                    controller: _cvvController,
                    decoration: const InputDecoration(
                      labelText: "CCV",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
                SizedBox(height: 40,),
                GestureDetector(
                  onTap: () {
                    print("Payment done!");
                  },
                  child: Center(
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.all(25),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: const Center(
                        child: Text("Pay!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}