import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/MyHomePage.dart';
import 'package:to_do_list_app/Provider/MainProvider.dart';
import 'package:to_do_list_app/SecondPage.dart';
import 'package:to_do_list_app/misc/BigDB.dart';
import 'package:to_do_list_app/misc/SystemBar.dart';
import 'package:to_do_list_app/misc/defaultColor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BigDB bigDB = BigDB();
  await bigDB.init('todolist');
  return runApp(
    ChangeNotifierProvider<MainProvider>(
      create: (_) => MainProvider(),
      builder: (_, __) => MyApp(bigDB: bigDB),
    ),
  );
}

class MyApp extends StatefulWidget {
  final BigDB bigDB;
  MyApp({this.bigDB});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<MainProvider>(context, listen: false).bigDB = widget.bigDB);
  }

  @override
  Widget build(BuildContext context) {
    //change the color of navigation bar and status bar
    systemBar();
    return MaterialApp(
      debugShowCheckedModeBanner: false, //<-- remove debug banner
      title: 'To-Do-List',
      theme: ThemeData(
        //<-- set theme color for the whole apps
        primarySwatch: defaultColor(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/queryPage': (context) => SecondPage(id: null),
      },
    );
  }
}
