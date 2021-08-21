import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/Provider/MainProvider.dart';
import 'package:to_do_list_app/SecondPage.dart';
import 'package:to_do_list_app/misc/ToDoList.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //-----------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<MainProvider>(context, listen: false).updateList());
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
        floatingActionButton: Consumer<MainProvider>(
          builder: (_, provider, __) => BounceInUp(
            //animation
            duration: Duration(milliseconds: 500),
            controller: (ctrl) async {
              await Future.delayed(Duration.zero);
              provider.animationController = ctrl;
            },
            manualTrigger: true,

            //--floating action button was separated into a new file (fab.dart)--
            child: FloatingActionButton(
              backgroundColor: Color(0xFFee5b25),
              onPressed: () {
                provider.animationController.reverse();
                Future.delayed(Duration(milliseconds: 500)).then(
                  (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondPage(id: null),
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
