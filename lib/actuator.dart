
import 'package:flutter/material.dart';
import 'lab_data.dart';

class ActuatorPage extends StatelessWidget {
  final LabData lab;
  final void Function(String, bool) onControl;

  const ActuatorPage({
    super.key,
    required this.lab,
    required this.onControl,
  });

  @override
  Widget build(BuildContext context) {

    return ListView(
      padding: EdgeInsets.all(20),
      children: [

        Text(
          'Actuator Control',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 20),

        // MANUAL BUZZER
        SwitchListTile(
          title: Text('Warning Buzzer'),
          subtitle: Text('Manual buzzer control'),
          secondary: Icon(
            Icons.notifications_active,
          ),

          value: lab.manualBuzzer,

          onChanged: lab.connected
              ? (value) {
            onControl('buzzer', value);
          }
              : null,
        ),

        Divider(),

        // MANUAL LED
        SwitchListTile(
          title: Text('Warning LED'),
          subtitle: Text('Manual LED control'),
          secondary: Icon(Icons.lightbulb),

          value: lab.manualLed,

          onChanged: lab.connected
              ? (value) {
            onControl('led', value);
          }
              : null,
        ),

        Divider(),

        SizedBox(height: 20),

        Text(
          'Current Output Status',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 15),

        ListTile(
          title: Text('LED Output'),
          trailing: Text(
            lab.connected
                ? (lab.led ? 'ON' : 'OFF')
                : '--',
          ),
        ),

        ListTile(
          title: Text('Buzzer Output'),
          trailing: Text(
            lab.connected
                ? (lab.buzzer ? 'ON' : 'OFF')
                : '--',
          ),
        ),

        SizedBox(height: 20),

        Text(
          'Safety Threshold Response',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 15),

        Text(
          '1. High Temperature = LED & Buzzer ON\n'
              '2. High Gas = LED & Buzzer ON\n'
              '3. Object Too Close = LED & Buzzer ON\n'
              '4. Manual switches can be used anytime',
        ),

        SizedBox(height: 20),

        Text(
          'When a threshold is reached, the LED and '
              'buzzer will remain ON even if the manual '
              'switches are OFF.',
        ),

        SizedBox(height: 20),

        Text(
          lab.connected
              ? 'Connected to Firebase'
              : 'Firebase Offline',
        ),

      ],
    );
  }
}
