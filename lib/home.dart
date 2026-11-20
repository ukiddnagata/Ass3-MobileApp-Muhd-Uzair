
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'lab_data.dart';
import 'dashboard.dart';
import 'actuator.dart';
import 'history.dart';
import 'sensor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // =====================================
  // VARIABLES
  // =====================================
  int selectedPage = 0;

  LabData lab = LabData();

  Timer? timer;
  bool loading = false;

  List<String> titles = [
    'Dashboard',
    'Actuator Control',
    'History',
    'Sensor Monitoring',
  ];

  // =====================================
  // START HOME PAGE
  // =====================================
  @override
  void initState() {
    super.initState();

    refreshData();

    timer = Timer.periodic(
      const Duration(seconds: 3),
          (timer) {
        refreshData();
      },
    );
  }

  // =====================================
  // READ FIREBASE DATA
  // =====================================
  Future<void> refreshData() async {

    if (loading) return;

    loading = true;

    try {
      await lab.readData();

    } finally {
      loading = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  // =====================================
  // CONTROL LED AND BUZZER
  // =====================================
  void controlDevice(
      String device,
      bool value,
      ) async {

    bool success = await lab.sendControl(
      device,
      value,
    );

    if (!mounted) return;

    setState(() {});

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Control failed'),
        ),
      );
    }
  }

  // =====================================
  // FIREBASE LOGOUT
  // =====================================
  Future<void> logout() async {

    try {

      await FirebaseAuth.instance.signOut();

      // main.dart DETECTS SIGN OUT
      // AND SHOWS LoginPage AUTOMATICALLY

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout gagal'),
        ),
      );
    }
  }

  // =====================================
  // STOP TIMER
  // =====================================
  @override
  void dispose() {

    timer?.cancel();

    super.dispose();
  }

  // =====================================
  // SELECT PAGE
  // =====================================
  Widget selectedBody() {

    if (selectedPage == 0) {

      return DashboardPage(
        lab: lab,
      );

    } else if (selectedPage == 1) {

      return ActuatorPage(
        lab: lab,
        onControl: controlDevice,
      );

    } else if (selectedPage == 2) {

      return HistoryPage(
        lab: lab,
        onRefresh: () {
          setState(() {});
        },
      );

    } else {

      return SensorPage(
        lab: lab,
        onRefresh: refreshData,
      );
    }
  }

  // =====================================
  // BUILD HOME PAGE
  // =====================================
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(titles[selectedPage]),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,

        actions: [

          IconButton(
            onPressed: logout,
            icon: const Icon(
              Icons.logout,
            ),
          ),

        ],
      ),

      body: selectedBody(),

      // =====================================
      // BOTTOM NAVIGATION
      // =====================================
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: selectedPage,

        type: BottomNavigationBarType.fixed,

        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,

        selectedFontSize: 10,
        unselectedFontSize: 10,

        showSelectedLabels: true,
        showUnselectedLabels: true,

        onTap: (index) {

          setState(() {
            selectedPage = index;
          });

        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings_remote),
            label: 'Actuator Control',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: 'Sensor Monitoring',
          ),

        ],
      ),
    );
  }
}
