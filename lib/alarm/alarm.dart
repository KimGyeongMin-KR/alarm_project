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



// import 'package:flutter/material.dart';
// import 'toggle_button.dart';

class Alram extends StatelessWidget {
  const Alram({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 5,
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 240,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: const [
                      Text(
                        "구로 디지털 단지역", // TODO: 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: const [
                      Text("매주 평일"),
                      Text("오전 6시부터"),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 70,
              height: 100,
              color: Colors.amber,
              child: const Text(
                '2km 전',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                ),
            ),
            Container(
              alignment: Alignment.center,
              width: 70,
              height: 100,
              child: const CupertinoSwitchExample()
            ),
          ],
        ),
      ),
    );
  }
}


class CupertinoSwitchExample extends StatefulWidget {
  const CupertinoSwitchExample({super.key});

  // const CupertinoSwitchExample({super.key, Key? key});

  @override
  State<CupertinoSwitchExample> createState() => _CupertinoSwitchExampleState();
}

class _CupertinoSwitchExampleState extends State<CupertinoSwitchExample> {
  bool switchValue = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
        activeTrackColor: Colors.green,
        activeColor: Colors.white,
        // This bool value toggles the switch.
        value: switchValue,
        onChanged: (bool? value) {
        // This is called when the user toggles the switch.
        setState(() {
          switchValue = value ?? false;
        });
      },
    );
  }
}