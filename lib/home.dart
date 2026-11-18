
import 'dart:async';
import 'package:flutter/material.dart';

import 'login.dart';
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

  @override
  void initState() {
    super.initState();

    refreshData();

    timer = Timer.periodic(
      Duration(seconds: 3),
          (timer) {
        refreshData();
      },
    );
  }

  // REFRESH SENSOR DATA
  Future<void> refreshData() async {
    if (loading) return;

    loading = true;

    await lab.readData();

    loading = false;

    if (mounted) {
      setState(() {});
    }
  }

  // CONTROL ACTUATOR
  void controlDevice(String device, bool value) async {
    bool success = await lab.sendControl(device, value);

    if (!mounted) return;

    setState(() {});

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Control failed'),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // SELECT PAGE
  Widget selectedBody() {

    if (selectedPage == 0) {
      return DashboardPage(lab: lab);

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

  // LOGOUT
  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
          (route) => false,
    );
  }

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
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      body: selectedBody(),

      // BOTTOM NAVIGATION
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
