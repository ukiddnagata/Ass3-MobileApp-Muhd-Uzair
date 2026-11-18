
import 'package:flutter/material.dart';
import 'lab_data.dart';

class SensorPage extends StatelessWidget {
  final LabData lab;
  final VoidCallback onRefresh;

  const SensorPage({
    super.key,
    required this.lab,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [

        Text(
          'Sensor Monitoring',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 15),

        Card(
          child: ListTile(
            leading: Icon(Icons.thermostat),
            title: Text('Temperature (DHT22)'),
            trailing: Text(
              lab.connected && lab.temperature != null
                  ? '${lab.temperature!.toStringAsFixed(1)} °C'
                  : '--',
            ),
          ),
        ),

        Card(
          child: ListTile(
            leading: Icon(Icons.water_drop),
            title: Text('Humidity (DHT22)'),
            trailing: Text(
              lab.connected && lab.humidity != null
                  ? '${lab.humidity!.toStringAsFixed(1)} %'
                  : '--',
            ),
          ),
        ),

        Card(
          child: ListTile(
            leading: Icon(Icons.air),
            title: Text('Gas / Smoke (MQ-2)'),
            trailing: Text(
              lab.connected
                  ? '${lab.gas ?? '--'} (ADC)'
                  : '--',
            ),
          ),
        ),

        Card(
          child: ListTile(
            leading: Icon(Icons.straighten),
            title: Text('Distance (Ultrasonic)'),
            trailing: Text(
              lab.connected && lab.distance != null
                  ? '${lab.distance!.toStringAsFixed(1)} cm'
                  : '--',
            ),
          ),
        ),

        SizedBox(height: 25),

        Text(
          'Sensor Status: ${lab.status}',
          style: TextStyle(fontSize: 18),
        ),

        SizedBox(height: 20),

        ElevatedButton(
          onPressed: onRefresh,
          child: Text('Refresh Sensor Data'),
        ),

        SizedBox(height: 15),

        Text(
          lab.connected
              ? 'Connected to ESP32'
              : 'ESP32 is not connected',
        ),

      ],
    );
  }
}
