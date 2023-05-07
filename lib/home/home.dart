import 'dart:async';
import 'dart:convert';
import 'package:alarm/header/header.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    super.initState();
    loadAlramList();
  }

  void alramRegister(alarmData) async {
    print('alramRdgiter');
    if (alarmData.containsKey('selectedPosition') &&
        alarmData.containsKey('selectedRange') &&
        alarmData.containsKey('selectedAlias')) {
      final String id = UniqueKey().toString(); // 고유한 ID 생성

      final Map<String, dynamic> newAlarm = {
        'latitude': alarmData['selectedPosition'].latitude,
        'longitude': alarmData['selectedPosition'].longitude,
        'range': alarmData['selectedRange'],
        'name': alarmData['selectedAlias'],
        'enabled': true, // 기본값으로 알람을 활성화 상태로 등록
      };

      alramList ??= []; // alramList가 null이면 빈 리스트로 초기화
      alramList!.add(newAlarm); // 알람을 alramList에 추가

      // SharedPreferences를 사용하여 알람 데이터를 로컬 기기 저장소에 저장
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      const String alarmsKey = 'locationAlramsKeepGoing_test3';

      final List<String> alarmListString =
          alramList!.map((alarm) => json.encode(alarm)).toList(); // JSON 직렬화
      await prefs.setStringList(alarmsKey, alarmListString);
      
      setState(() {
        // 알람이 추가되었으므로 상태를 업데이트하여 화면에 반영
      });
    }
  }
  Future<void> loadAlramList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const String alarmsKey = 'locationAlramsKeepGoing_test3';
    final List<String>? alarmListString = prefs.getStringList(alarmsKey);

  if (alarmListString != null) {
    alramList = alarmListString.map((alarmString) {
      final Map<String, dynamic> alarmMap = json.decode(alarmString);
      return Map<String, dynamic>.from(alarmMap);
    }).toList();
    print(alramList);
  } else {
    alramList = [];
  }

    setState(() {});
  }

  Future<void> saveAlramList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      const String alarmsKey = 'locationAlramsKeepGoing_test3';

      final List<String> alarmListString =
          alramList!.map((alarm) => json.encode(alarm)).toList(); // JSON 직렬화
      await prefs.setStringList(alarmsKey, alarmListString);
  }

  void deleteAlarm(int index) async {
    alramList!.removeAt(index); // 알람 삭제
    await saveAlramList();

    setState(() {
      // 알람이 삭제되었으므로 상태를 업데이트하여 화면에 반영
    });
  }

  void alramEditer(Map<String, dynamic> data) {
    editMode = data['editMode'];
    setState(() {
    });
    return;
  }
  void movePage() {
  editMode = false;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: KeepGoingHeader(
          alramRegist: alramRegister,
          alramEditCallbackFunction: alramEditer,
          moveCallback: movePage,
        ),
      ),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: alramList?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final Map<String, dynamic> alarm = alramList![index];
                final String name = alarm['name'];
                final bool isEnabled = alarm['enabled'];

                return ListTile(
                  title: Text(name),
                  trailing: editMode
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteAlarm(index),
                        )
                      : Switch(
                          value: isEnabled,
                          onChanged: (value) {
                            alramList![index]['enabled'] = value;
                            saveAlramList();
                            setState(() {
                            });
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    ),
  );
}

}