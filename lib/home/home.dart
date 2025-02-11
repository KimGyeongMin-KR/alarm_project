import 'dart:async';
import 'dart:convert';
import 'package:alarm/header/header.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
   
  @override
  void initState() {
    super.initState();


    Timer(const Duration(seconds: 2), () {
      moveScreen();
    });
    
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
  bool? atLeastOneActivate;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void _alarmOn(){

  }

  void _alarmOff(){

  }

  void _checkOnAlarms(){

  }

  void _phoneComeBackFromAirplaneMode(){

  }
  void startBackgroundGeolocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const String alarmsKey = 'locationAlramsKeepGoing_test3';

    final List<String>? alarmListString = prefs.getStringList(alarmsKey);

    if (alarmListString != null) {
      alramList = alarmListString.map((alarmString) {
        final Map<String, dynamic> alarmMap = json.decode(alarmString);
        return Map<String, dynamic>.from(alarmMap);
      }).toList();
    } else {
      alramList = [];
    }

    // Check if any alarm is enabled
    bool atLeastOneActivate = alramList!.any((alarm) => alarm['enabled'] == true);

    // Start background geolocation only if at least one alarm is enabled
    if (atLeastOneActivate) {
      // Configure and start background geolocation
      bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10.0,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: false,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      )).then((bg.State state) {
        if (!state.enabled) {
          bg.BackgroundGeolocation.start();
        }
      });

      // Handle background geolocation events
      bg.BackgroundGeolocation.onLocation((bg.Location location) {
        // Calculate distance for each alarm
        for (var alarm in alramList!) {
          double distance = calculateDistance(location, alarm);

          // Check if distance is within range
          if (distance <= alarm['range']) {
            // Check if screen is on
            if (isScreenOn()) {
              // Trigger simple phone alarm
              triggerPhoneAlarm();
            } else {
              // Show alarm notification on lock screen
              showLockScreenAlarm();
            }
          }
        }
      });
    }
  }

  double calculateDistance(bg.Location location, Map<String, dynamic> alarm) {
    // Calculate distance between two points using latitude and longitude
    double latitude = alarm['latitude'];
    double longitude = alarm['longitude'];

    // Implement distance calculation logic here
    // ...

    return 0.1;
  }

  bool isScreenOn() {
    // Implement screen status check logic here
    // ...

    return true;
  }

  void triggerPhoneAlarm() {
    // Implement phone alarm logic here
    // ...
  }

  void showLockScreenAlarm() {
    // Implement lock screen alarm notification logic here
    // ...
  }
  @override
  void initState() {
    super.initState();
    loadAlramList();

    // Fired whenever a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[location] - $location');
      // TODO 알람 on된 것들을 찾기 시작
      // 시동 꺼졌다 켜졌을 때 
    });

    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      print('[motionchange] - $location');
    });

    // Fired whenever the state of location-services changes.  Always fired at boot
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      print('[providerchange] - $event');
    });

    ////
    // 2.  Configure the plugin
    //
    bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10.0,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: false,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE
    )).then((bg.State state) {
      if (!state.enabled) {
        ////
        // 3.  Start the plugin.
        //
        bg.BackgroundGeolocation.start();
      }
    });
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

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
  }

  Future<void> scheduleNotification() async {
    const int id = 0;
    const String title = 'Flutter 알림';
    const String body = '알림 내용입니다.';
    const String payload = 'Custom_Sound';

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: null, iOS: null);

    await flutterLocalNotificationsPlugin.schedule(
        id, title, body, DateTime.now().add(const Duration(seconds: 5)),
        platformChannelSpecifics,
        payload: payload);
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
                var range = alarm["range"];
                return ListTile(
                  title: Row(
                    children: [
                      Text(name),
                      const Spacer(), // Add Spacer to push additional text to the left
                      Text('$range Km'), // Replace 'Additional Text' with your desired text
                    ],
                  ),
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
                            setState(() {});
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

}