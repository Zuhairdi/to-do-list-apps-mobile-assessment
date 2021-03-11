import 'package:flutter/material.dart';
import 'package:to_do_list_app/misc/defaultColor.dart';

FloatingActionButton fab({@required VoidCallback onPressed}) {
  return FloatingActionButton(
    backgroundColor: fabColor(),
    onPressed: onPressed,
    child: Icon(
      Icons.add,
      size: 30.0,
      color: Colors.white,
    ),
  );
}
