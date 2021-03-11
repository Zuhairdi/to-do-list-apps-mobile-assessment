import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list_app/MyHomePage.dart';
import 'package:to_do_list_app/misc/defaultColor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //change the color of navigation bar and status bar
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: defaultColor(),
        systemNavigationBarColor: defaultColor(),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false, //<-- remove debug banner
      title: 'To-Do-List',
      theme: ThemeData(
        //<-- set theme color for the whole apps
        primarySwatch: defaultColor(),
      ),
      home: MyHomePage(), //<-- enter the 1st page
    );
  }
}
