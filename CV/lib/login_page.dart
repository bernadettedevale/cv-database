import 'homepage.dart';
import 'signup.dart'; // Import your SignupPage
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passToggle = true;

  Future<void> login() async {
    // Proceed with signup
    final response = await http.post(
      Uri.parse('http://localhost/bern database/login.php'),
      body: {
        'username': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      // Display a message to the user based on the response from the server
      if (result['message'] == 'Login successful') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyApp(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
          ),
        );
      }
    } else {
      // Handle errors
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: Color.fromARGB(255, 83, 3, 77),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: const Image(
                  image: AssetImage('images/bern.png'),
                  height: 100,
                  width: 100,
                ),
              ),
              TextFormField(
                style: const TextStyle(
                  fontFamily: 'RobotoMono',
                  color: Color.fromARGB(255, 6, 79, 97),
                ),
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 15, 15, 15),
                    fontFamily: 'RobotoMono',
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: const TextStyle(
                  fontFamily: 'RobotoMono',
                  color: Color.fromARGB(255, 6, 79, 97),
                ),
                controller: _passwordController,
                obscureText: passToggle,
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 15, 15, 15),
                      fontFamily: 'RobotoMono',
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          passToggle = !passToggle;
                        });
                      },
                      child: Icon(
                          passToggle ? Icons.visibility : Icons.visibility_off),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (_passwordController.text.length < 6) {
                    return 'Password Length should be more than 6 characters';
                  } else if (!RegExp(
                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$')
                      .hasMatch(value)) {
                    return 'The password needs to be valid.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 198, 135, 204),
                  padding: const EdgeInsets.symmetric(horizontal: 350),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    login();
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 218, 193, 218),
                  padding: const EdgeInsets.symmetric(horizontal: 340),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignupPage(),
                    ),
                  );
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 218, 193, 218),
    );
  }
}
