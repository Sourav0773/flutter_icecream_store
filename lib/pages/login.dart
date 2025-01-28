import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {

  // Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false; // Controls the login button loader
  bool isPageLoading = true; // Controls the page loader on screen load

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Login function to send data to the backend
  Future<void> login() async {
    String email = emailController.text;
    String password = passwordController.text;

    // Check if fields are empty
    if (email.isEmpty || password.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields!')),
        );
      }
      return;
    }

    // Show loading indicator for the login process
    setState(() {
      isLoading = true;
    });

    // Prepare data to send to backend
    Map<String, String> loginData = {
      'email': email,
      'password': password,
    };

    try {
      // Send POST request to the login API
      var response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(loginData),
      );

      // Reset the loading state after the request
      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        // Successful login
        var responseBody = json.decode(response.body);
        String token = responseBody['token']; // API response with JWT

        // Buffer effect to show a delay
        await Future.delayed(Duration(seconds: 2));

        // Check if the user is admin or user
        var userResponse = await http.get(
          Uri.parse('http://localhost:5000/api/auth/admin-only'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (mounted) {
          if (userResponse.statusCode == 200) {
            // User is an admin
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    Text('Login Successful! Admin'),
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to the admin portal
            Navigator.pushReplacementNamed(context, '/admin');
          } else {
            // Not an admin, so check if it's a user
            var userResponse = await http.get(
              Uri.parse('http://localhost:5000/api/auth/user'),
              headers: {
                'Authorization': 'Bearer $token',
              },
            );

            if (mounted) {
              if (userResponse.statusCode == 200) {
                // User is successfully logged in as a regular user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        Text('Login Successful! User'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                // Navigate to the user portal
                Navigator.pushReplacementNamed(context, '/welcomeUser');
              } else {
                // User is not authorized (access denied)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Access Denied, not an admin nor user'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          }
        }
      } else {
        // Handle error response from API
        if (mounted) {
          var errorResponse = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorResponse['message'] ?? 'Login failed')),
          );
        }
      }
    } catch (e) {
      // Handle any error that occurs during the HTTP request
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      // Ensure the loading state is reset in case of failure
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Page loading
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isPageLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login to IceCream Shop',
          style: GoogleFonts.pacifico(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade800, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            if (isPageLoading)
              Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              ),
            if (!isPageLoading)
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 80),
                      // Ice Cream logo
                      Image.asset(
                        'assets/login_icon.png',
                        width: 130,
                        height: 130,
                      ),
                      SizedBox(height: 40),
                      // Login form with Card
                      Card(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 25),
                          child: Column(
                            children: [
                              // Email Field
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle:
                                      TextStyle(color: Colors.amber.shade400),
                                  prefixIcon: Icon(Icons.email,
                                      color: Colors.amber.shade400),
                                  filled: true,
                                  fillColor: Colors.black,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                        color: Colors.amber.shade400, width: 2),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: Colors.white),
                              ),

                              SizedBox(height: 20),

                              // Password Field
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle:
                                      TextStyle(color: Colors.amber.shade400),
                                  prefixIcon: Icon(Icons.lock,
                                      color: Colors.amber.shade400),
                                  filled: true,
                                  fillColor: Colors.black,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                        color: Colors.amber.shade400, width: 2),
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),

                              SizedBox(height: 30),

                              // Gold Login Button
                              ElevatedButton(
                                onPressed: login,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  backgroundColor: Colors.amber.shade600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 10,
                                ),
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white) // Show loading spinner
                                    : Text(
                                        'Login',
                                        style: GoogleFonts.lobster(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                              ),
                              SizedBox(height: 20),
                              // Forgot Password Text
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Forgot Password clicked!')),
                                  );
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.lobster(
                                    color: Colors.amber.shade400,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
