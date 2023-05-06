// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class GoogleMapPage extends StatefulWidget {
//   const GoogleMapPage({super.key});

//   @override
//   _GoogleMapPageState createState() => _GoogleMapPageState();
// }

// class _GoogleMapPageState extends State<GoogleMapPage> {
//   late GoogleMapController mapController;
//   LatLng? markerPosition;
  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Google 지도'),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: (GoogleMapController controller) {
//               mapController = controller;
//             },
//             onCameraMove: (CameraPosition position) {
//               setState(() {
//                 markerPosition = position.target;
//               });
//             },
//             markers: <Marker>{
//               Marker(
//                 markerId: const MarkerId('selected_location'),
//                 position: markerPosition ?? const LatLng(37.5665, 126.9780),
//               ),
//             },
//             initialCameraPosition: const CameraPosition(
//               target: LatLng(37.5665, 126.9780),
//               zoom: 12.0,
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       // 주소로 찾기 버튼을 클릭했을 때의 동작
//                       // TODO: 주소로 찾기 기능 구현
//                     },
//                     child: const Text('주소로 찾기'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).pop(markerPosition);
//                     },
//                     child: const Text('선택하기'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kpostal/kpostal.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  GoogleMapController? mapController;
  Future<LatLng>? markerPosition;
  LatLng? centerPosition;
  // LatLng? targetPosition;
  double selectedRange = 1.0; // 초기 선택 범위
  List? mapCenterXY;
  double previousZoom = 0.0;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google 지도'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            myLocationButtonEnabled: false,
            minMaxZoomPreference: const MinMaxZoomPreference(13.5, 15.0),
            onCameraMove: (CameraPosition position) {
              double currentZoom = position.zoom;
              if (currentZoom != previousZoom) {
                // Zoom level이 변경되었을 때 처리할 로직
                previousZoom = currentZoom;
              }
              setState(() {
                // 마커의 위치는 변경하지 않고 가운데 위치만 가져옴
                centerPosition = position.target;
              });
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.5665, 126.9780),
              zoom: 12.0,
            ),
            // markers: <Marker>{
            //   Marker(
            //     markerId: const MarkerId('11'),
            //     position: centerPosition ?? const LatLng(37.5665, 126.9780),
            //   ),
            //   Marker(
            //     markerId: const MarkerId('11'),
            //     position: targetPosition ?? const LatLng(37.5665, 126.9780),
            //   )
            // }
          ),
      
          Positioned(
            bottom: getDeviceCenter()[1],
            left: getDeviceCenter()[0],
            // right: 16.0,
            child: CustomPaint(
            painter: RangeCirclePainter(
              center: getDeviceCenter(),
              range: selectedRange,
              zoomLevel: previousZoom),
          ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 40,
            bottom: MediaQuery.of(context).size.height / 2 - appBarHeight,
            child: const Icon(Icons.location_on, size: 80, color: Colors.blue),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => KpostalView(
                                useLocalServer: true,
                                localPort: 8080,
                                kakaoKey: '19280c2c4fe89e14b8fe58ae96218245',
                                callback: (Kpostal result) {
                                  centerPosition = LatLng(result.kakaoLatitude!.toDouble(), result.kakaoLongitude!.toDouble());
                                  print(result);
                                  setState(() {
                                  });
                                  setCameraPosition();
                              },
                    ),
                  ),
                );
              },
                      child: const Text('주소로 찾기'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        // '선택하기' 버튼 클릭 시 동작
                        // TODO: 구현해야 할 내용 작성
                        Navigator.of(context).pop(centerPosition);
                      },
                      child: const Text('선택하기'),
                    ),
                  ],
                ),
                Slider(
                  value: selectedRange,
                  min: 0.5,
                  max: 2.0,
                  divisions: 3,
                  label: '${selectedRange}km',
                  onChanged: (double value) {
                    setState(() {
                      selectedRange = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  getDeviceCenter() {
    double mapCenterX = MediaQuery.of(context).size.width / 2;
    double mapCenterY = MediaQuery.of(context).size.height / 2 - 50;
    // print('$mapCenterX $mapCenterY 나여');
    return mapCenterXY = [mapCenterX, mapCenterY];
  }
  void setCameraPosition() {
    mapController!.moveCamera(
      CameraUpdate.newLatLng(centerPosition!),
    );
  }
}


class RangeCirclePainter extends CustomPainter {
  final List? center;
  final double range;
  final double zoomLevel;

  RangeCirclePainter({this.center, required this.range, required this.zoomLevel});

  @override
  void paint(Canvas canvas, Size size) {
    // print(center);
    if (center != null) {
      final radius = range / getMetersPerPixel(zoomLevel);
      const centerPoint = Offset(0, 0);

      final circlePaint = Paint()
        ..color = Colors.green.withOpacity(0.12)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(centerPoint, radius, circlePaint);

      final borderPaint = Paint()
        ..color = Colors.green.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(centerPoint, radius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  static double getMetersPerPixel(double zoomLevel) {
    return 120.03392 * cos(0) / pow(2, zoomLevel);
  }
}
