import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const platform = const MethodChannel('samples.flutter.dev/battery');
  static const platform2 = const MethodChannel('samples.flutter.dev/myMethodChannel');

  String _batteryLevel = 'Unknown battery level.';
  String _customMethodCall = 'Unknown method call.';
  String _customMethodCallWithArg = 'Unknown method call with arg.';
  String _arg = '-';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                FloatingActionButton(
                  heroTag: 'battery',
                  backgroundColor: Colors.red,
                  child: Icon(Icons.battery_unknown,),
                  onPressed: _getBatteryLevel,
                ),

                FloatingActionButton(
                  heroTag: 'myMethodCall',
                  backgroundColor: Colors.green,
                  child: Icon(Icons.chat_bubble),
                  onPressed: _getMyMethodCall,
                ),

                FloatingActionButton(
                  heroTag: 'myMethodCallWithArg',
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.chat),
                  onPressed: _getMyMethodCallWithArg,
                )

              ],
            ),
          ),
          Column(
            children: <Widget>[
              Center(
                child: Text(
                  'This is only available for android',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Center(
                child: Text(
                  _batteryLevel,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  _customMethodCall,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _customMethodCallWithArg,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blue),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'send arg: ' + _arg,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.orange),
                  ),
                ],
              )

            ],
          )
        ],
      ),
    );
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      //only android
      if(!Platform.isAndroid) {
        return;
      }
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch(e) {
      batteryLevel = 'Failed to get battery level: ${e.message}';
    }

    setState((){
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _getMyMethodCall() async {
    String res;
    try {
      //only android
      if(!Platform.isAndroid) {
        return;
      }
      final String result = await platform2.invokeMethod('myChannelCalled');
      res = result;
    } on PlatformException catch(e) {
      res = 'Failed to get custom method call: ${e.message}';
    }

    setState((){
      _customMethodCall = res;
    });
  }

  Future<void> _getMyMethodCallWithArg() async {
    String res;
    try {
      //only android
      if(!Platform.isAndroid) {
        return;
      }
      final String result = await platform2.invokeMethod('myChannelCalledWithArg', {'created': 'cjh'});
      res = result;
    } on PlatformException catch(e) {
      res = 'Failed to get custom method call with arg: ${e.message}';
    }

    setState((){
      _customMethodCallWithArg = 'Called method in andorid with arg';
      _arg = res;
    });
  }

}
