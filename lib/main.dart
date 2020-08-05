import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light, primaryColor: Color.fromRGBO(58, 66, 86, 1)),
      home: StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot){
          final state = snapshot.data;
          if(state == BluetoothState.on){
           return BluetoothOnScreen();
          }else{
            return BluetoothOffScreen(
              state: state,
            );
          }
        },
      ),
    );
  }
}


class BluetoothOnScreen extends StatefulWidget {
  @override
  _BluetoothOnScreenState createState() => _BluetoothOnScreenState();
}

class _BluetoothOnScreenState extends State<BluetoothOnScreen> {
  static String targetDeviceName = "rafael-Inspiron-5558";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sound Level Meter - Tutorial YT"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Connect Device"),
          onPressed: _deviceSearchingStart,
        ),
      ),
    );
  }

  _deviceSearchingStart(){
    FlutterBlue.instance
        .startScan(timeout: Duration(seconds: 3))
        .whenComplete(() {

          FlutterBlue.instance.startScan();
          _scanResult();
    });
  }

  _scanResult(){
    FlutterBlue.instance.scanResults.first.then((element){
      print("Device Num: ${element}");
      element.forEach((value) {
        print('**** ${value.device.id} / ${value.device.name} ****');
        if(value.device.name == targetDeviceName){
          print("**** FOUND Target Device ****");
        }
      });
    });
  }

}



class BluetoothOffScreen extends StatelessWidget {

  const BluetoothOffScreen({Key key, this.state}) : super(key: key);
  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200,
              color: Colors.white54
            ),
            Text("Bluetooth Adapter is ${state.toString().substring(15)}")
          ],
        ),
      ),
    );
  }
}
