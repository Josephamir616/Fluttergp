import 'package:flutter/material.dart';
import 'package:untitled/pages/HomePage.dart';

class PaymentPage extends StatefulWidget {
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name on card',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name on card';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Card number',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your card number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _cvvController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'CVV',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your CVV';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Proceed with payment
                    }
                  },
                  child: Text('Proceed'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}