import 'dart:async';
import 'package:alarm/header/header.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  void moveScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainPage(title: 'hi',)),
    );
  }
   void _requestLocationPermission() async {

// 위치 권한 요청
  var location = Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  serviceEnabled = await location.serviceEnabled();
  print(serviceEnabled);
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    print(permissionGranted);
    permissionGranted = await location.requestPermission();
    
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  // 현재 위치 정보 가져오기
  LocationData locationData = await location.getLocation();

}
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      moveScreen();
    });
    _requestLocationPermission();
    
  }

  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.blueGrey,
      child: Align(
        // alignment: const FractionalOffset(0.5, /3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text(
              '편하게 일 보세요.',
              style: TextStyle(
                fontSize: 22,
                color: Colors.green,
                decoration: TextDecoration.none,
              ),
            ),
            Icon(Icons.add, size: 350,),
            Text(
              'Keep Going',
              style: TextStyle(
                fontSize: 30,
                color: Colors.green,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  bool editMode = false;
  List<Map<String, dynamic>>? alramList;

  void _incrementCounter() {
    setState(() {
    });
  }
  @override
  void initState() {

  }

  void alramRegister(alarmData) {

    return;
  }

  void alramEditer() {

    return;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: KeepGoingHeader(
          alramRegistCallbackFunction: alramRegister,
          alramEditCallbackFunction: alramEditer,
        ),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'zzz',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

