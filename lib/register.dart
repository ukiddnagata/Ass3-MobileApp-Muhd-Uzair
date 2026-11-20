
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool loading = false;
  bool hidePassword = true;

  // REGISTER USING FIREBASE AUTHENTICATION
  Future<void> register() async {

    String email = emailController.text.trim();
    String password = passwordController.text;
    String confirmPassword =
        confirmPasswordController.text;

    // CHECK EMPTY FIELDS
    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {

      showMessage('Please complete all fields.');
      return;
    }

    // CHECK PASSWORD LENGTH
    if (password.length < 6) {

      showMessage(
        'Password must contain at least 6 characters.',
      );
      return;
    }

    // CHECK PASSWORD CONFIRMATION
    if (password != confirmPassword) {

      showMessage('Passwords do not match.');
      return;
    }

    setState(() {
      loading = true;
    });

    try {

      // CREATE FIREBASE ACCOUNT
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      // FIREBASE AUTOMATICALLY SIGNS IN
      // main.dart WILL SHOW HomePage
      Navigator.of(context).popUntil(
            (route) => route.isFirst,
      );

    } on FirebaseAuthException catch (e) {

      String message = 'Registration failed. Please try again.';

      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered.';

      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';

      } else if (e.code == 'weak-password') {
        message = 'Please choose a stronger password.';

      } else if (e.code == 'operation-not-allowed') {
        message = 'Email registration is not enabled.';

      } else if (e.code == 'network-request-failed') {
        message = 'Please check your internet connection.';

      } else if (e.code == 'too-many-requests') {
        message = 'Too many attempts. Please try again later.';
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
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Sign Up'),
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
                Icons.person_add,
                size: 70,
                color: Colors.blueAccent,
              ),

              const SizedBox(height: 20),

              const Text(
                'Create New Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Register with your email address',
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
                  hintText: 'Create a password',
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
              ),

              const SizedBox(height: 20),

              // CONFIRM PASSWORD FIELD
              TextField(
                controller: confirmPasswordController,
                obscureText: hidePassword,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),

              const SizedBox(height: 30),

              // REGISTER BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: loading ? null : register,

                  child: loading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // BACK TO LOGIN
              TextButton(
                onPressed: loading
                    ? null
                    : () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Already have an account? Login',
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
