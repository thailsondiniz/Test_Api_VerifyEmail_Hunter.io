import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController emailController = TextEditingController();
  bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> checkEmailExists(String email) async {
    const apiKey = '';
    final url = Uri.parse(
        'https://api.hunter.io/v2/email-verifier?email=$email&api_key=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data']['status'] == 'valid') {
          setState(() {
            const snackBar = SnackBar(
              backgroundColor: Colors.green,
              content: Text('Valid email'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        } else {
          setState(() {
            const snackBar = SnackBar(
              backgroundColor: Colors.red,
              content: Text('Invalid or non-existent email'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        }
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Email'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email.';
                      }
                      if (!isValidEmail(value)) {
                        return 'Invalid email format.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Email'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final email = emailController.text.trim();
                          checkEmailExists(email);
                        }
                      },
                      child: Text(
                        'Validar',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
