
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool hidePassword = true;

  // LOGIN USING FIREBASE AUTHENTICATION
  Future<void> login() async {

    String email = emailController.text.trim();
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showMessage('Please enter your email and password.');
      return;
    }

    setState(() {
      loading = true;
    });

    try {

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // main.dart automatically opens HomePage
      // when login is successful.

    } on FirebaseAuthException catch (e) {

      String message = 'Login failed. Please try again.';

      if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';

      } else if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        message = 'Incorrect email or password.';

      } else if (e.code == 'user-disabled') {
        message = 'This account has been disabled.';

      } else if (e.code == 'too-many-requests') {
        message = 'Too many login attempts. Try again later.';

      } else if (e.code == 'network-request-failed') {
        message = 'Please check your internet connection.';
      }

      showMessage(message);

    } catch (e) {

      showMessage('An unexpected error occurred.');

    } finally {

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // OPEN REGISTER PAGE
  void openRegister() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  // DISPLAY ERROR MESSAGE
  void showMessage(String message) {

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.science,
                size: 80,
                color: Colors.blueAccent,
              ),

              const SizedBox(height: 20),

              const Text(
                'Smart Laboratory Safety',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Sign in to your account',
              ),

              const SizedBox(height: 30),

              // EMAIL FIELD
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),

              const SizedBox(height: 20),

              // PASSWORD FIELD
              TextField(
                controller: passwordController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock),

                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
                onSubmitted: (_) {
                  if (!loading) {
                    login();
                  }
                },
              ),

              const SizedBox(height: 30),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: loading ? null : login,

                  child: loading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // REGISTER LINK
              TextButton(
                onPressed: loading ? null : openRegister,
                child: const Text(
                  "Don't have an account? Sign Up",
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
