import 'package:flutter/services.dart';
import 'package:to_do_list_app/misc/defaultColor.dart';

void systemBar() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: defaultColor(),
      systemNavigationBarColor: defaultColor(),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}
