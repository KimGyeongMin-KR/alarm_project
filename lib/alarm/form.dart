
import 'package:alarm/header/header.dart';
import 'package:alarm/map/google_map.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
class AlramFormPage extends StatefulWidget {
  const AlramFormPage({super.key, required this.title});

  final String title;

  @override
  State<AlramFormPage> createState() => _AlramFormPageState();
}

class _AlramFormPageState extends State<AlramFormPage> {

  Map<String, dynamic>? alarmData;
  String? selectedAlias;
  LatLng? selectedPosition;
  double? selectedRange;
  final Completer<GoogleMapController> mapController = Completer();

  @override
  void dispose() {
    super.dispose();
  }


  void selectDestination() {
    // TODO: 구글 맵 페이지로 이동하여 목적지 선택
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const GoogleMapPage()),
    ).then((alramData) {
      if (alramData != null) {
        alarmData = alramData;
        selectedPosition = alramData["selectedPosition"];
        selectedRange = alramData["selectedRange"];
        selectedAlias = alramData["selectedAlias"];
        setState(() {
          print(alramData);
        });
        // openAliasModal();
        if (selectedPosition != null) {
            mapController.future.then((controller) {
              controller.moveCamera(
                CameraUpdate.newLatLng(selectedPosition!),
              );
            });
          }
      }
    });
  }

  void removeAlias() {
    setState(() {
      selectedAlias = null;
    });
  }

  dynamic registAlram() {
    if(
      alarmData != null &&
      selectedAlias != null
    ){
      Navigator.pop(context, alarmData);
      return;
    }
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('위치, 위치 이름, 알람 범위를 설정해 주세요.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: KeepGoingFormHeader(callbackFunction: registAlram),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                const Text('목적지: '),
                Expanded(
                  child: selectedAlias != null
                      ? Row(
                          children: [
                            Text(selectedAlias!),
                            IconButton(
                              onPressed: removeAlias,
                              icon: const Icon(Icons.clear),
                            ),
                          ],
                        )
                      : ElevatedButton(
                          onPressed: selectDestination,
                          child: const Text('목적지 선택 >'),
                        ),
                ),
              ],
            ),
          ),
          Text('알람 감지 범위: ${selectedRange ?? 0} km'), // 범위 문구
          Container(
            width: 300,
            height: 150,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  if (!mapController.isCompleted) {
                    mapController.complete(controller);
                  }
                  // mapController.complete(controller);
                },
                initialCameraPosition: CameraPosition(
                  target: selectedPosition ?? const LatLng(37.5665, 126.9780), // 선택한 위치 또는 기본 위치
                  zoom: 12.0,
                ),
                markers: <Marker>{
                  Marker(
                    markerId: const MarkerId('selectedPosition'),
                    position: selectedPosition ?? const LatLng(37.5665, 126.9780), // 선택한 위치 또는 기본 위치
                  ),
                },
                rotateGesturesEnabled: false,
                scrollGesturesEnabled: false,
                tiltGesturesEnabled: false,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: false,
                // liteModeEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



