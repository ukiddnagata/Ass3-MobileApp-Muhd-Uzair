import 'package:flutter/material.dart';
import 'lab_data.dart';

class DashboardPage extends StatelessWidget {
  final LabData lab;

  const DashboardPage({
    super.key,
    required this.lab,
  });

  @override
  Widget build(BuildContext context) {

    Color statusColor = Colors.green;

    if (!lab.connected ||
        lab.status == 'SENSOR ERROR') {
      statusColor = Colors.grey;
    } else if (lab.status == 'WARNING') {
      statusColor = Colors.orange;
    } else if (lab.status == 'DANGER') {
      statusColor = Colors.red;
    }

    return ListView(
      padding: EdgeInsets.all(15),
      children: [

        Text(
          'Laboratory Safety Status',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 15),

        Card(
          child: ListTile(
            title: Text('Overall Status'),
            trailing: Text(
              lab.status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        SizedBox(height: 20),

        Text(
          'Sensor Readings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        ListTile(
          leading: Icon(Icons.thermostat),
          title: Text('Temperature (DHT22)'),
          trailing: Text(
            lab.connected && lab.temperature != null
                ? '${lab.temperature!.toStringAsFixed(1)} °C'
                : '--',
          ),
        ),

        ListTile(
          leading: Icon(Icons.water_drop),
          title: Text('Humidity (DHT22)'),
          trailing: Text(
            lab.connected && lab.humidity != null
                ? '${lab.humidity!.toStringAsFixed(1)} %'
                : '--',
          ),
        ),

        ListTile(
          leading: Icon(Icons.air),
          title: Text('Gas / Smoke (MQ-2)'),
          trailing: Text(
            lab.connected
                ? '${lab.gas ?? '--'} (ADC)'
                : '--',
          ),
        ),

        ListTile(
          leading: Icon(Icons.straighten),
          title: Text('Distance (Ultrasonic)'),
          trailing: Text(
            lab.connected && lab.distance != null
                ? '${lab.distance!.toStringAsFixed(1)} cm'
                : '--',
          ),
        ),

        Divider(),

        Text(
          'Actuator Status',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        ListTile(
          leading: Icon(Icons.notifications_active),
          title: Text('Warning Buzzer'),
          trailing: Text(
            lab.connected
                ? (lab.buzzer ? 'ON' : 'OFF')
                : '--',
          ),
        ),

        ListTile(
          leading: Icon(Icons.lightbulb),
          title: Text('Warning LED'),
          trailing: Text(
            lab.connected
                ? (lab.led ? 'ON' : 'OFF')
                : '--',
          ),
        ),

        Divider(),

        ListTile(
          leading: Icon(Icons.wifi),
          title: Text('Device Connection'),
          trailing: Text(
            lab.connected ? 'ONLINE' : 'OFFLINE',
          ),
        ),

        ListTile(
          leading: Icon(Icons.settings_remote),
          title: Text('Control Mode'),
          trailing: Text(
            lab.connected
                ? (lab.autoMode ? 'AUTO' : 'MANUAL')
                : '--',
          ),
        ),

      ],
    );
  }
}
