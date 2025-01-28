import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {
  // Controllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false; // Controls the signup button loader
  bool isPageLoading = true; // Controls the page loader on screen load

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Signup function to send data to the backend
  Future<void> signup() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    // Check if fields are empty
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      // Show a snackbar message if any field is empty
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields!')),
        );
      }
      return;
    }

    // Check if password is at least 6 characters
    if (password.length < 6) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password must be at least 6 characters!')),
        );
      }
      return;
    }

    // Show loading indicator for the signup process
    setState(() {
      isLoading = true;
    });

    // Prepare data to send to backend
    Map<String, String> signupData = {
      'username': username,
      'email': email,
      'password': password,
    };

    try {
      // Send POST request to the signup API
      var response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(signupData),
      );

      // Avoid using BuildContext after async gaps
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      if (response.statusCode == 201) {
        // Successful signup
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signup Successful!')),
          );
        }

        // Only navigate if the widget is still there in widget tree (mounted)
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        // Handle error response from API
        if (mounted) {
          var errorResponse = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(errorResponse['message'] ?? 'Signup failed')
              ),
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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Page loading
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isPageLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create an Account',
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
                      // Signup form with Card
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
                              // Username Field
                              TextField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle:
                                      TextStyle(color: Colors.amber.shade400),
                                  prefixIcon: Icon(Icons.person,
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

                              SizedBox(height: 20),

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

                              // Gold Signup Button
                              ElevatedButton(
                                onPressed: signup,
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
                                        color: Colors
                                            .white) // Show loading spinner
                                    : Text(
                                        'Sign Up',
                                        style: GoogleFonts.lobster(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                              ),
                              SizedBox(height: 20),
                              // Already have an account Text
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: Text(
                                  'Already have an account? Login',
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
