
import 'package:flutter/material.dart';
import 'account_data.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  void register() {

    String username = usernameController.text.trim();
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter username and password'),
        ),
      );

      return;
    }

    if (AccountData.users.containsKey(username)) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username already exists'),
        ),
      );

      return;
    }

    // SAVE NEW ACCOUNT
    AccountData.users[username] = password;

    Navigator.pop(
      context,
      {
        'username': username,
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Sign Up'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),

        child: Column(
          children: [

            const SizedBox(height: 20),

            const Text(
              'Create Account',
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
              onPressed: register,
              child: const Text('Sign Up'),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Already have an account? Login here',
              ),
            ),

          ],
        ),
      ),
    );
  }
}
