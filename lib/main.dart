
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'login.dart';
import 'home.dart';

// =====================================
// MAIN
// =====================================
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// =====================================
// MAIN APPLICATION
// =====================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Laboratory Safety',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          // WAIT FOR FIREBASE AUTH
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // SHOW LOGIN IF NOT SIGNED IN
          // ALSO REJECT OLD ANONYMOUS LOGIN
          final user = snapshot.data;

          if (user == null || user.isAnonymous) {
            return const LoginPage();
          }

          // EMAIL/PASSWORD LOGIN SUCCESS
          return const HomePage();
        },
      ),
    );
  }
}
