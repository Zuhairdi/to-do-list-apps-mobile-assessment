import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/Provider/MainProvider.dart';
import 'package:to_do_list_app/SecondPage.dart';
import 'package:to_do_list_app/misc/BigDB.dart';
import 'package:to_do_list_app/misc/TimeHandler.dart';
import 'package:to_do_list_app/misc/defaultColor.dart';

class ItemList extends StatelessWidget {
  ItemList({
    Key key,
    @required this.data,
    @required this.onEdit,
  }) : super(key: key);

  final DataModel data;
  final VoidCallback onEdit;

  snackBar({VoidCallback onDelete}) => SnackBar(
        content: Text('Remove task?'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          textColor: defaultColor(),
          onPressed: () {
            onDelete();
          },
          label: 'OK',
        ),
      );
  snackBarWarning() => SnackBar(
        content: Text('Complete task cannot be edited'),
        duration: Duration(seconds: 2),
      );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) async {
        if (data.isComplete) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarWarning());
          return false;
        }
        return true;
      },
      onDismissed: (direction) {
        onEdit();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondPage(id: data.id)),
        );
      },
      key: UniqueKey(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
            ),
          ),
          child: Container(
            color: Colors.transparent,
            height: 200,
            width: 300,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.grey,
                title: Text(
                  data.title,
                  style: TextStyle(color: Colors.black),
                ),
                actions: [
                  Consumer<MainProvider>(
                    builder: (_, provider, __) => IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          snackBar(onDelete: () {
                            provider.deleteTask(data);
                          }),
                        );
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ),
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text('Time remaining:'),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TimerText(
                        dataModel: data,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      MyCheckBox(data: data),
                      Text(
                          '${data.isComplete ? 'Complete' : 'Check the box if the task is complete'}'),
                    ],
                  ),
                ],
              ),
              bottomNavigationBar: Container(
                height: 20,
                child: Column(
                  children: [
                    Text(
                      '${data.isComplete ? '' : 'Swipe the task left or right to update the data'}',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyCheckBox extends StatefulWidget {
  const MyCheckBox({
    Key key,
    @required this.data,
  }) : super(key: key);

  final DataModel data;

  @override
  _MyCheckBoxState createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  //bool _state = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (_, provider, __) => Checkbox(
        onChanged: (isTick) {
          provider.updateCheck(widget.data, isTick);
        },
        value: widget.data.isComplete,
      ),
    );
  }
}

class TimerText extends StatefulWidget {
  const TimerText({
    Key key,
    @required this.dataModel,
  }) : super(key: key);

  final DataModel dataModel;

  @override
  _TimerTextState createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  Timer t;
  String remaining = '--';

  @override
  void dispose() {
    super.dispose();
    t?.cancel();
  }

  @override
  void initState() {
    super.initState();
    DateTime start =
        DateTime.fromMillisecondsSinceEpoch(widget.dataModel.startDate);
    DateTime end =
        DateTime.fromMillisecondsSinceEpoch(widget.dataModel.endDate);
    if (!widget.dataModel.isComplete) {
      t = Timer.periodic(Duration(seconds: 1), (timer) {
        TimeHandler timeHandler = TimeHandler(
          start: start,
          end: end,
        );
        setState(() {
          remaining = timeHandler.calculate();
          if (remaining == 'Ongoing') t.cancel();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        '${widget.dataModel.isComplete ? 'The task is completed' : remaining}');
  }
}
