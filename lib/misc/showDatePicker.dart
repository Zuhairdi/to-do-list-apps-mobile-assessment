import 'package:flutter/material.dart';
import 'package:to_do_list_app/misc/TimeFormatter.dart';
import 'package:to_do_list_app/misc/dateDropdownMenu.dart';

/*
*   This file was created to handle the range picker dialog
*/

Future<void> selectDate(BuildContext context,
    {Function(RangePickerHandler) onDateSelected,
    VoidCallback onCanceled}) async {
  //call a datepicker dialog and wait for user input
  final DateTimeRange pickedRange = await showDateRangePicker(
    context: context,
    firstDate: DateTime.now(),
    lastDate: DateTime(2050),
  );
  //check if the return DateTimeRange is available or not, if true skip the function and exit.
  if (pickedRange == null) {
    onCanceled();
    return;
  }
  //get the selection and only save it if start and end value available
  if (pickedRange.start != null && pickedRange.end != null) {
    onDateSelected(
      RangePickerHandler(
        label: label(pickedRange.start, pickedRange.end),
        startDate: timeFormatter(pickedRange.start),
        endDate: timeFormatter(pickedRange.end),
        range: pickedRange,
      ),
    );
  }
}

String label(DateTime start, DateTime end) {
  return timeFormatter(start) + ' to ' + timeFormatter(end);
}
