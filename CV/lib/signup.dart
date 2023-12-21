import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String passwordErrorText = '';
  String usernameErrorText = '';
  bool _passwordVisible = false;

  Future<void> _signup() async {
    // Perform password validation
    if (!_validatePassword(passwordController.text)) {
      setState(() {
        passwordErrorText =
            'Password must contain capital letters, numbers, special characters, and be at least 8 characters long.';
      });
      return;
    } else {
      setState(() {
        passwordErrorText = '';
      });
    }

    // Perform username validation
    if (!_validateUsername(usernameController.text)) {
      setState(() {
        usernameErrorText = 'Username must end with "@gmail.com"';
      });
      return;
    } else {
      setState(() {
        usernameErrorText = '';
      });
    }

    // Proceed with signup
    final response = await http.post(
      Uri.parse('http://localhost/bern database/signup.php'),
      body: {
        'username': usernameController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      // Display a message to the user based on the response from the server
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
        ),
      );
    } else {
      // Handle errors
      print('Error: ${response.statusCode}');
    }
  }

  // Password validation function
  bool _validatePassword(String password) {
    // Add your password validation logic here
    // For example, requiring capital letters, numbers, special characters, and a minimum length of 8
    RegExp passwordRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  // Username validation function
  bool _validateUsername(String username) {
    // Add your username validation logic here
    // For example, requiring the username to end with "@gmail.com"
    return true;
    // return username.endsWith('@gmail.com');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 83, 3, 77),
        title: Text(
          'Sign Up',
          style: TextStyle(color: const Color.fromARGB(255, 243, 242, 242)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create New User',
              style: TextStyle(
                color: const Color.fromARGB(255, 15, 15, 15),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              style: TextStyle(
                color: const Color.fromARGB(255, 6, 79, 97),
                fontFamily: 'RobotoMono',
              ),
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle:
                    TextStyle(color: const Color.fromARGB(255, 15, 15, 15)),
                errorText: usernameErrorText,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              style: TextStyle(
                color: const Color.fromARGB(255, 6, 79, 97),
                fontFamily: 'RobotoMono',
              ),
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle:
                    TextStyle(color: const Color.fromARGB(255, 15, 15, 15)),
                errorText: passwordErrorText,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              obscureText: !_passwordVisible,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 198, 135, 204),
                padding: const EdgeInsets.symmetric(horizontal: 340),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                // Perform signup when the button is pressed
                _signup();
              },
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 218, 193, 218),
    );
  }
}
