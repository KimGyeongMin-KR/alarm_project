import 'package:alarm/header/header.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
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


  double _latitude = 0.0;
  double _longitude = 0.0;
  final _aliasController = TextEditingController();
  final _addressController = TextEditingController();
  final _soundController = TextEditingController();

  // 폼 키 초기화
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // 위치 정보 가져오기
    _getCurrentLocation();
  }

  // 위치 정보 가져오기
  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    print(permission);
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission != LocationPermission.whileInUse){
      permission = await Geolocator.requestPermission();
    }
    if(permission != LocationPermission.always){
      await Geolocator.openAppSettings();
      print('hi');
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      print(e);
      print('나 오류');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hi'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: MapSample(),
      ),
    );
  }

  Container newMethod(BuildContext context) {
    return Container(
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
                    useLocalServer: true,
                    localPort: 8080,
                    kakaoKey: '19280c2c4fe89e14b8fe58ae96218245',
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
                Text('현재 lat: $_latitude'),
                Text('현재 log: $_longitude'),
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
    );
  }
}


class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, 122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.413021, 127.136660),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}