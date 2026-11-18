
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class LabData {

  // FIREBASE DATABASE
  final DatabaseReference db =
  FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    'https://smart-lab-safety-uzair-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  // SENSOR DATA
  double? temperature;
  double? humidity;
  int? gas;
  double? distance;

  // MANUAL CONTROL
  bool manualLed = false;
  bool manualBuzzer = false;

  // EXPECTED OUTPUT STATUS
  bool led = false;
  bool buzzer = false;

  // Kept for existing dashboard compatibility
  bool autoMode = false;

  // THRESHOLDS
  double tempLimit = 35.0;
  int gasLimit = 1500;
  double distanceLimit = 20.0;

  // STATUS
  bool connected = false;
  String status = 'OFFLINE';
  String previousStatus = 'OFFLINE';

  // HISTORY
  List<Map<String, String>> history = [];
  List<String> alerts = [];

  // CURRENT TIME
  String get currentTime {

    DateTime now = DateTime.now();

    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
  }

  // =====================================
  // READ FIREBASE DATA
  // =====================================
  Future<void> readData() async {

    try {

      final snapshot = await db.get();

      if (!snapshot.exists ||
          snapshot.value is! Map) {

        connected = false;
        status = 'NO DATA';
        return;
      }

      final root = Map<String, dynamic>.from(
        snapshot.value as Map,
      );

      final data = Map<String, dynamic>.from(
        (root['lab_data'] as Map?) ?? {},
      );

      if (data.isEmpty) {

        connected = false;
        status = 'NO DATA';
        return;
      }

      final settings = Map<String, dynamic>.from(
        (root['settings'] as Map?) ?? {},
      );

      final actuators = Map<String, dynamic>.from(
        (root['actuators'] as Map?) ?? {},
      );

      // SENSOR DATA
      temperature =
          (data['temperature'] as num?)?.toDouble();

      humidity =
          (data['humidity'] as num?)?.toDouble();

      gas =
          (data['gas_level'] as num?)?.toInt();

      distance =
          (data['distance_cm'] as num?)?.toDouble();

      // THRESHOLDS
      tempLimit =
          (settings['max_temp'] as num?)?.toDouble()
              ?? 35.0;

      gasLimit =
          (settings['max_gas'] as num?)?.toInt()
              ?? 1500;

      distanceLimit =
          (settings['max_distance'] as num?)?.toDouble()
              ?? 20.0;

      // MANUAL SWITCH STATES
      manualLed =
          actuators['warning_light'] == true;

      manualBuzzer =
          actuators['warning_alarm'] == true;

      // HAZARD DETECTION
      bool highTemp =
          temperature != null &&
              temperature! >= tempLimit;

      bool highGas =
          gas != null &&
              gas! >= gasLimit;

      bool tooClose =
          distance != null &&
              distance! > 0 &&
              distance! <= distanceLimit;

      bool hazard =
          highTemp || highGas || tooClose;

      // FINAL OUTPUT
      // Manual OR Threshold
      led = manualLed || hazard;
      buzzer = manualBuzzer || hazard;

      // FIREBASE READ SUCCESS
      connected = true;

      // SAFETY STATUS
      if (temperature == null ||
          humidity == null ||
          gas == null ||
          distance == null ||
          distance == 999.0) {

        status = 'SENSOR ERROR';

      } else if (highGas) {

        status = 'DANGER';

      } else if (highTemp || tooClose) {

        status = 'WARNING';

      } else {

        status = 'SAFE';
      }

      // ALERTS
      if (status != previousStatus &&
          status != 'SAFE') {

        alerts.insert(
          0,
          '$currentTime - $status',
        );
      }

      previousStatus = status;

      if (alerts.length > 30) {
        alerts.removeLast();
      }

      // HISTORY
      history.insert(0, {

        'time': currentTime,

        'temp':
        temperature?.toStringAsFixed(1) ?? '--',

        'humidity':
        humidity?.toStringAsFixed(1) ?? '--',

        'gas':
        gas?.toString() ?? '--',

        'distance':
        distance?.toStringAsFixed(1) ?? '--',

        'status': status,
      });

      if (history.length > 30) {
        history.removeLast();
      }

    } catch (e) {

      connected = false;
      status = 'OFFLINE';

      debugPrint('Firebase Read Error: $e');
    }
  }

  // =====================================
  // CONTROL LED / BUZZER
  // =====================================
  Future<bool> sendControl(
      String device,
      bool value,
      ) async {

    try {

      if (device == 'led') {

        await db.child(
          'actuators/warning_light',
        ).set(value);

      } else if (device == 'buzzer') {

        await db.child(
          'actuators/warning_alarm',
        ).set(value);

      } else {

        return false;
      }

      await readData();

      return true;

    } catch (e) {

      debugPrint('Control Error: $e');
      return false;
    }
  }

  // =====================================
  // CHANGE THRESHOLD
  // =====================================
  Future<bool> sendSetting(
      String type,
      double value,
      ) async {

    try {

      if (type == 'temp') {

        await db.child(
          'settings/max_temp',
        ).set(value);

      } else if (type == 'gas') {

        await db.child(
          'settings/max_gas',
        ).set(value.round());

      } else if (type == 'distance') {

        await db.child(
          'settings/max_distance',
        ).set(value);

      } else {

        return false;
      }

      await readData();

      return true;

    } catch (e) {

      debugPrint('Setting Error: $e');
      return false;
    }
  }
}
