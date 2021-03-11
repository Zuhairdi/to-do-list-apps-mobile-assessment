import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:to_do_list_app/misc/BigDB.dart';
import 'package:to_do_list_app/misc/TimeFormatter.dart';
import 'package:to_do_list_app/misc/Toast.dart';
import 'package:to_do_list_app/misc/appbar_second_page.dart';
import 'package:to_do_list_app/misc/dateDropdownMenu.dart';
import 'package:to_do_list_app/misc/showDatePicker.dart';

class SecondPage extends StatefulWidget {
  VoidCallback refresh;
  int ID;
  SecondPage({this.refresh, this.ID});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String _toDoListTitle;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();
  Set<RangePickerHandler> dateList = Set<RangePickerHandler>();
  RangePickerHandler _selection;
  BigDB bigDB = BigDB();

  //-------------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    //init SQL database and trigger certain function after it's ready
    bigDB.init('todolist').then((value) {
      // only do this if this page receive a data from 1st page.
      if (widget.ID != null) {
        bigDB.readSingle(widget.ID).then((data) {
          //filling passes data to the section
          _textEditingController.text = data.title;
          DateTime _startDate =
              DateTime.fromMillisecondsSinceEpoch(data.startDate);
          DateTime _endDate = DateTime.fromMillisecondsSinceEpoch(data.endDate);
          DateTimeRange _range =
              DateTimeRange(start: _startDate, end: _endDate);
          RangePickerHandler pickerHandler = RangePickerHandler(
            label: label(_startDate, _endDate),
            startDate: timeFormatter(_startDate),
            endDate: timeFormatter(_endDate),
            range: _range,
          );
          _selection = pickerHandler;
          dateList.add(pickerHandler);
          //reload
          setState(() {});
        });
      }
    });

    //initialize database
    dateList.add(RangePickerHandler(
        label: RangePickerHandler.defaultLabel)); //initialize cache array
  }

  //-------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          //preventing the widget to be pushed by the keyboard layout
          resizeToAvoidBottomInset: false,
          //----------------------- top -------------------------------------------------
          //check appbar_second_page.dart
          appBar: ab(context),
          //----------------------- middle ----------------------------------------------
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                // this page will consist of 3 section, where each of them will have a title text
                // which make the total widget in the column to be six
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // --- space --------------------------------------------------------
                    SizedBox(
                      height: 50,
                    ),

                    // --- 1.title --------------------------------------------------------
                    Text(
                      'To-Do title',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                      textAlign: TextAlign.start,
                    ),

                    // --- 2.TextField to obtain input for To-Do-List title --------------
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _textEditingController,
                        maxLines: 7,
                        textCapitalization: TextCapitalization.sentences,
                        onSaved: (value) => _toDoListTitle = value,
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter task title';
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.zero),
                          hintText: 'Please key in your To-Do title here',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    // --- 3.Title for Start Date ---------------------------------------------
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Start Date',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    // --- 4.Selection of start date ------------------------------------------
                    DateDropDown(
                      selection: _selection,
                      isStartDate: true,
                      dateList: dateList,
                      onSelectedDate: (data) {
                        setState(() {
                          _selection = data;
                          dateList.add(data);
                        });
                      },
                      onCanceled: () => setState(() {
                        _selection = null;
                      }),
                    ),
                    // --- 5.Title for End Date ------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                      child: Text(
                        'Estimate End Date',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    // --- 6.Selection of end date ---------------------------------------------
                    DateDropDown(
                      isStartDate: false,
                      selection: _selection,
                      dateList: dateList,
                      onSelectedDate: (data) {
                        setState(() {
                          _selection = data;
                          dateList.add(data);
                        });
                      },
                      onCanceled: () => setState(() {
                        _selection = null;
                      }),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),

          //----------------------- bottom -------------------------------------------------
          //this is a button to submit
          bottomNavigationBar: Container(
            color: Colors.black,
            child: Bounce(
              duration: Duration(milliseconds: 200),
              onPressed: () {
                // 1. check form whether it is empty or not
                if (!_formKey.currentState.validate()) return;
                // 2. Save the input into a variable
                _formKey.currentState.save();

                // 3. Start saving (add/update) *delay 200ms for button animation
                Future.delayed(Duration(milliseconds: 200)).then((value) {
                  widget.ID == null
                      //if create new task
                      ? bigDB
                          .add(
                          title: _toDoListTitle,
                          startDate:
                              _selection.range.start.millisecondsSinceEpoch,
                          endDate: _selection.range.end.millisecondsSinceEpoch,
                          isComplete: false,
                        )
                          .then((id) {
                          Toast('Data added successfully');
                          widget.refresh();
                          Navigator.pop(context);
                        })
                      //if updating existing task
                      : bigDB
                          .update(
                          ID: widget.ID,
                          title: _toDoListTitle,
                          startDate:
                              _selection.range.start.millisecondsSinceEpoch,
                          endDate: _selection.range.end.millisecondsSinceEpoch,
                          isComplete: false,
                        )
                          .then((id) {
                          Toast('Data edit successfully');
                          widget.refresh();
                          Navigator.pop(context);
                        });
                });
              },
              // button content
              child: Container(
                height: 65,
                alignment: Alignment.center,
                color: Colors.black,
                child: Text(
                  widget.ID == null ? 'Create Now' : 'Edit Now',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          )),
    );
  }
}
