import 'package:alarm/alarm/form.dart';
import 'package:flutter/material.dart';

class KeepGoingHeader extends StatefulWidget {
  final Function alramRegist;
  final Function alramEditCallbackFunction;
  final Function moveCallback;
  const KeepGoingHeader({
    super.key,
    required this.alramRegist,
    required this.alramEditCallbackFunction,
    required this.moveCallback
  });

  @override
  State<KeepGoingHeader> createState() => _KeepGoingHeaderState();
}

class _KeepGoingHeaderState extends State<KeepGoingHeader>{
    bool editMode = false;
    String editSectionName = '편집';


    @override
    void initState() {
      super.initState();
    }

  void alramRegist(alramData) {
    widget.alramRegist(alramData);
  }

  void alramEditCallbackFunction() {
    editSectionName = editMode? '편집': '취소';
    // editMode = editMode? false : true;
    editMode = !editMode;

    setState(() {
    });
    Map<String, dynamic> data = {
      'editMode': editMode
    };
    widget.alramEditCallbackFunction(data);
  }

  void moveCallback(){
    widget.moveCallback();
  }

  void setEditMode(){
    editSectionName = '편집';
    editMode = false;
    setState(() {
    });
    Map<String, dynamic> data = {
      'editMode': editMode
    };
    widget.alramEditCallbackFunction(data);
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
                      icon: Text(
                        editSectionName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        // TODO: '편집' 버튼을 눌렀을 때 실행할 코드 작성
                        alramEditCallbackFunction();
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
                      onPressed: () async {
                        setEditMode();
                        dynamic alarmData = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const AlramFormPage(title: 'title')),
                        );
                        if (alarmData != null){
                          alramRegist(alarmData);
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
  }
}


class KeepGoingFormHeader extends StatefulWidget {
  final Function callbackFunction;
  const KeepGoingFormHeader({super.key, required this.callbackFunction});

  @override
  State<KeepGoingFormHeader> createState() => _KeepGoingFormHeaderState();
}

class _KeepGoingFormHeaderState extends State<KeepGoingFormHeader> {
  void alramRegister() {
    widget.callbackFunction();
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
                        '취소',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.red
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      '알람 추가',
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
                      icon: const Text(
                        '등록',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.green
                        ),
                      ),
                      onPressed: alramRegister,
                    ),
                  ),
                ),
              ],
            );
  }
}