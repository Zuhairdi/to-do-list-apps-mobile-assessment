import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/SecondPage.dart';
import 'package:to_do_list_app/misc/BigDB.dart';
import 'package:to_do_list_app/misc/ToDoList.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BigDB bigDB = BigDB();
  List<DataModel> mList = List<DataModel>.empty(growable: true);
  AnimationController _controller;
  //-----------------------------------------------------------------------------------
  //function to call reload action of the list
  _refresh() {
    mList.clear();
    bigDB.init('todolist').then((_) {
      bigDB.read().then((value) {
        setState(() {
          _controller.forward();
          mList = value;
        });
      });
    });
  }

  //-----------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    //call reload during init
    _refresh();
  }

  //-----------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFefefef),
        //----------------------- top -------------------------------------------------
        appBar: AppBar(
          title: Text(
            'To-Do-List',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        //----------------------- middle -------------------------------------------------
        body: ToDoList(),

        //----------------------- bottom -------------------------------------------------
        floatingActionButton: BounceInUp(
          //animation
          duration: Duration(milliseconds: 500),
          controller: (ctrl) => _controller = ctrl,
          manualTrigger: true,

          //--floating action button was separated into a new file (fab.dart)--
          child: FloatingActionButton(
            backgroundColor: Color(0xFFee5b25),
            onPressed: () {
              _controller.reverse();
              Future.delayed(Duration(milliseconds: 500)).then(
                (value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondPage(),
                    ),
                  );
                },
              );
            },
            child: Icon(
              Icons.add,
              size: 30.0,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
