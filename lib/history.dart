
import 'package:flutter/material.dart';
import 'lab_data.dart';

class HistoryPage extends StatelessWidget {
  final LabData lab;
  final VoidCallback onRefresh;

  const HistoryPage({
    super.key,
    required this.lab,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(15),
      children: [

        Text(
          'Historical Sensor Data',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 10),

        Text('Last 30 sensor readings'),

        SizedBox(height: 15),

        ElevatedButton(
          onPressed: () {
            lab.history.clear();
            onRefresh();
          },
          child: Text('Clear History'),
        ),

        SizedBox(height: 15),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          child: DataTable(
            columns: [
              DataColumn(label: Text('Time')),
              DataColumn(label: Text('Temp')),
              DataColumn(label: Text('Humidity')),
              DataColumn(label: Text('Gas')),
              DataColumn(label: Text('Distance')),
              DataColumn(label: Text('Status')),
            ],

            rows: lab.history.map((data) {
              return DataRow(
                cells: [
                  DataCell(Text(data['time'] ?? '')),
                  DataCell(Text(data['temp'] ?? '')),
                  DataCell(Text(data['humidity'] ?? '')),
                  DataCell(Text(data['gas'] ?? '')),
                  DataCell(Text(data['distance'] ?? '')),
                  DataCell(Text(data['status'] ?? '')),
                ],
              );
            }).toList(),
          ),
        ),

      ],
    );
  }
}
