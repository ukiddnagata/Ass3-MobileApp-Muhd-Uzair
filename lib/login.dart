
import 'package:flutter/material.dart';
import 'register.dart';
import 'home.dart';
import 'account_data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  void login() {

    String username = usernameController.text.trim();
    String password = passwordController.text;

    if (AccountData.users[username] == password) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong username or password'),
        ),
      );
    }
  }

  void openRegister() async {

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );

    if (!mounted) return;

    if (result != null) {

      setState(() {
        usernameController.text = result['username'];
        passwordController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Login Page'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),

        child: Column(
          children: [

            const SizedBox(height: 20),

            const Text(
              'Login',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                hintText: 'Enter Your Username',
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter Your Password',
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: openRegister,
              child: const Text(
                "Don't have an account? Sign Up",
              ),
            ),

          ],
        ),
      ),
    );
  }
}
