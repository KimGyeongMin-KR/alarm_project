
import 'package:alarm/alarm/form.dart';
import 'package:flutter/material.dart';

class KeepGoingHeader extends StatefulWidget {
  const KeepGoingHeader({super.key});

  @override
  State<KeepGoingHeader> createState() => _KeepGoingHeaderState();
}

class _KeepGoingHeaderState extends State<KeepGoingHeader> {
  void onClicked() {
    setState(() {
    
    });
  }

  @override
  Widget build(BuildContext context){
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: const Text(
                        '편집',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        // TODO: '편집' 버튼을 눌렀을 때 실행할 코드 작성
                        
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Keep Going',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const App()),
                          // MaterialPageRoute(builder: (context) => const LocationBasedAlarmWidget()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
  }
}