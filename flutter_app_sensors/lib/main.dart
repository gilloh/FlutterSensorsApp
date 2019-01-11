import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
//import 'package:async/async.dart';
//import 'snake.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData.dark(),
      home: SensorsPage(title: 'Sensors Demo'),
    );
  }
}

class SensorsPage extends StatefulWidget {
  final String title;

  SensorsPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SensorsPageState();
}

class _SensorsPageState extends State<SensorsPage> {
//  static const int _snakeRows = 20;
//  static const int _snakeColumns = 20;
//  static const double _snakeCellSize = 10.0;

  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Widget _buildTextBlock(String sensorType, List<String> sensorData, Color color) {
    return Text(
      '$sensorType\n$sensorData\n',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40.0,
        color: color,
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer = _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope = _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
//    final List<String> userAccelerometer = _userAccelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sensors Demo',
          style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Card(
          semanticContainer: true,
          margin: EdgeInsets.all(40.0),
          elevation: 10.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTextBlock("Accelerometer", accelerometer, Colors.greenAccent),
              _buildTextBlock("Gyroscope", gyroscope, Colors.redAccent),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) subscription.cancel();
  }

  @override
  void initState() {
    super.initState();

    _streamSubscriptions.add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions.add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
  }
}
