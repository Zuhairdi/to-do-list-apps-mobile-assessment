import 'package:flutter/material.dart';

AppBar ab(BuildContext context) {
  return AppBar(
    leading: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Icon(Icons.chevron_left),
      ),
    ),
    leadingWidth: 20.0,
    title: Text(
      'Add new To-Do-List',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
