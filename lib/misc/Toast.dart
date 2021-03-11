import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.amber,
      textColor: Colors.white,
      fontSize: 16.0);
}
