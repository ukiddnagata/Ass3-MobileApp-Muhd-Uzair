
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'login.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // CONNECT FLUTTER TO FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // LOGIN FIREBASE ANONYMOUSLY
  try {

    await FirebaseAuth.instance.signInAnonymously();

    debugPrint('Firebase Connected Successfully!');

  } catch (e) {

    debugPrint('Firebase Auth Error: $e');
  }

  // START APPLICATION
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    ),
  );
}
