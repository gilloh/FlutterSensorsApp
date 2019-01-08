import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:async/async.dart';
import 'snake.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
  static const int _snakeRows = 20;
  static const int _snakeColumns = 20;
  static const double _snakeCellSize = 10.0;

  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

//  static final Duration _timerDuration = Duration(seconds: 10);
//  RestartableTimer _timer = RestartableTimer(_timerDuration, _showWarningDialog);
//  static int currentDuration = _timer.tick;

//  static void _showWarningDialog() {
//    print('$_timer');
//  }

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer = _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope = _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.blue[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.red),
              ),
              child: SizedBox(
                  height: _snakeRows * _snakeCellSize,
                  width: _snakeColumns * _snakeCellSize,
                  child: Snake(
                    rows: _snakeRows,
                    columns: _snakeColumns,
                    cellSize: _snakeCellSize,
                  )
              ),
            ),
          ),
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '> Accelerometer: $accelerometer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.only(left: 16.0),
          ),
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "> Gyroscope: $gyroscope",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.only(left: 16.0),
          ),
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "> UserAccelerometer: $userAccelerometer",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.only(left: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text("Sensors Demo"),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions)
      subscription.cancel();
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

//        if (event.y < 0.01 && !_timer.isActive) {
//          print("HERE");
//          this._timer.reset();
//        }
      });
    }));
  }
}

















