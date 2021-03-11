import 'package:flutter/material.dart';
import 'package:to_do_list_app/misc/showDatePicker.dart';

/*
*   This file is a customized widget for dropdown
*/

class DateDropDown extends StatefulWidget {
  bool isStartDate;
  RangePickerHandler selection;
  Function(RangePickerHandler) onSelectedDate;
  VoidCallback onCanceled;
  Set<RangePickerHandler> dateList;

  //constructor
  DateDropDown(
      {this.isStartDate,
      this.selection,
      this.onSelectedDate,
      this.onCanceled,
      this.dateList});

  @override
  _dateDropDownState createState() => _dateDropDownState();
}

class _dateDropDownState extends State<DateDropDown> {
  @override
  Widget build(BuildContext context) {
    //start customizing DDBFF
    return DropdownButtonFormField<RangePickerHandler>(
      value: widget.selection,

      //-- properties section ------------------------------------------
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.zero),
      ),
      hint: Text(
        'Select a date',
        style: TextStyle(
          color: Colors.grey.shade400,
          fontStyle: FontStyle.italic,
        ),
      ),
      isExpanded: true,
      //-- end of properties section -----------------------------------
      // validate the date section
      validator: (value) {
        if (value == null) return 'Please select date';
        return null;
      },
      //if the dropdown item was clicked
      onChanged: (value) {
        //this function will call DateRangePicker dialog if first label was click
        if (value.label == RangePickerHandler.defaultLabel) {
          selectDate(
            context,
            onDateSelected: (data) {
              widget.onSelectedDate(data);
              setState(() {});
            },
            onCanceled: () {
              widget.onCanceled();
            },
          );
        } else {
          widget.onSelectedDate(value);
        }
      },
      //--- builder for list in the dropdown ----------------------------------
      items: widget.dateList.map((value) {
        return DropdownMenuItem(
          child: Text(value.label),
          value: value,
          onTap: () {},
        );
      }).toList(),
      selectedItemBuilder: (context) {
        return widget.dateList.map((value) {
          return widget.isStartDate
              ? Text(value.startDate ?? 'Date not selected')
              : Text(value.endDate ?? 'Date not selected');
        }).toList();
      },
      //--- end of the builder ------------------------------------------------
    );
  }
}

//enum for input data from DateRangePicker
class RangePickerHandler {
  static String defaultLabel = 'Click here to select date';
  String label;
  String startDate;
  String endDate;
  DateTimeRange range;
  RangePickerHandler({this.label, this.startDate, this.endDate, this.range});
}
