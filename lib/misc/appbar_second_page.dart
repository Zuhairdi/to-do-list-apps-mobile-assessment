import 'package:flutter/material.dart';

AppBar ab(BuildContext context) {
  return AppBar(
    leading: SizedBox(),
    leadingWidth: 20.0,
    title: Text(
      'Add new To-Do-List',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
