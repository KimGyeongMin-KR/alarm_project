import 'package:alarm/alarm/alarm.dart';
import 'package:alarm/header/header.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';
// import 'package:kopo/kopo.dart';

class AlarmFormPage extends StatefulWidget {
  const AlarmFormPage({super.key, required this.title});


  final String title;

  @override
  State<AlarmFormPage> createState() => _AlarmFormPageState();
}

class _AlarmFormPageState extends State<AlarmFormPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: KeepGoingHeader(),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
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




class App extends StatefulWidget{
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String postCode = '-';
  String address = '-';
  String latitude = '-';
  String longitude = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hi'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KpostalView(
                      useLocalServer: false,
                      localPort: 1024,
                      // kakaoKey: '{Add your KAKAO DEVELOPERS JS KEY}',
                      callback: (Kpostal result) {
                        setState(() {
                          postCode = result.postCode;
                          address = result.address;
                          latitude = result.latitude.toString();
                          longitude = result.longitude.toString();
                          kakaoLatitude = result.kakaoLatitude.toString();
                          kakaoLongitude =
                              result.kakaoLongitude.toString();
                        });
                      },
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              child: const Text(
                'Search Address',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  const Text('postCode',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('result: $postCode'),
                  const Text('address',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('result: $address'),
                  const Text('LatLng', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      'latitude: $latitude / longitude: $longitude'),
                  const Text('through KAKAO Geocoder',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      'latitude: $kakaoLatitude / longitude: $kakaoLongitude'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}