import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationBasedAlarmWidget extends StatefulWidget {
  const LocationBasedAlarmWidget({super.key});

  @override
  State<LocationBasedAlarmWidget> createState() =>
      _LocationBasedAlarmWidgetState();
}

class _LocationBasedAlarmWidgetState extends State<LocationBasedAlarmWidget> {
  // 위치 정보 변수 초기화
  double _latitude = 0.0;
  double _longitude = 0.0;

  // 입력 필드 관련 변수 초기화
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
        title: const Text('위치 기반 알람'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '현재 위치',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5.0),
              Text('위도: $_latitude'),
              const SizedBox(height: 5.0),
              Text('경도: $_longitude'),
              const SizedBox(height: 5.0),
              TextFormField(
                controller: _aliasController,
                decoration: const InputDecoration(
                  labelText: '별칭',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '별칭을 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: '주소',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '주소를 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _soundController,
                decoration: const InputDecoration(
                  labelText: '사운드',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '사운드를 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // 입력 필드 유효성 검사
                  if (_formKey.currentState!.validate()) {
                    // 알람 등록 코드 작성
                  }
                },
                child: const Text('알람 등록'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
