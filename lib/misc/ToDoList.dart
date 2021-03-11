import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list_app/SecondPage.dart';
import 'package:to_do_list_app/misc/BigDB.dart';
import 'package:to_do_list_app/misc/TimeFormatter.dart';
import 'package:to_do_list_app/misc/TimeHandler.dart';
import 'package:to_do_list_app/misc/Toast.dart';

class ToDoList extends StatefulWidget {
  List<BigDBHandler> dataList;
  VoidCallback refreshList;
  Function(int) deleteFromDatabase;
  Function(BigDBHandler, bool) updateDatabase;
  AnimationController controller;

  ToDoList(
      {this.dataList,
      this.refreshList,
      this.deleteFromDatabase,
      this.controller,
      this.updateDatabase});

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  //this function will hold the refresh command until snack bar disappear (2 seconds)
  Future<void> waitForSnackBar() {
    return Future.delayed(Duration(seconds: 2)).then((value) {
      widget.refreshList();
    });
  }

  //---------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    //check for item available in the list, if available, draw card with feature
    return widget.dataList.length > 0
        //if true
        ? ListView.builder(
            itemCount: widget.dataList.length,
            padding: EdgeInsets.only(bottom: 100.0),
            //The builder of list started here
            itemBuilder: (context, index) {
              BigDBHandler data = widget.dataList[index];
              DateTime start =
                  DateTime.fromMillisecondsSinceEpoch(data.startDate);
              DateTime end = DateTime.fromMillisecondsSinceEpoch(data.endDate);
              TimeHandler t = TimeHandler(
                start: start,
                end: end,
              );
              return Dismissible(
                key: UniqueKey(),
                // onDismissed will be called when the user swipe the card to the left or right.
                // 2 second will be delayed before the panel refresh, if the user click delete in the snackbar,
                // the entries will be removed
                onDismissed: (direction) {
                  widget.controller.reverse();
                  setState(() {
                    widget.dataList.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      // content of the snackbar consist of button with text, click this button to trigger the SQL helper to remove the entries
                      content: FlatButton(
                        child: Container(
                          child: Text(
                            'Click here to delete',
                            style: TextStyle(
                                color: Colors.cyanAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        splashColor: Colors.white,
                        onPressed: () {
                          widget.deleteFromDatabase(data.ID);
                        },
                      ),
                      onVisible: () {
                        // 2 s countdown
                        waitForSnackBar();
                      },
                    ),
                  );
                },
                child: Bounce(
                  // --- animation when the user pressed the card -------------------
                  duration: Duration(milliseconds: 200),
                  onPressed: () {
                    if (!data.isComplete) {
                      widget.controller.reverse();
                      // the navigator was delayed for 500ms to give the feeling of pressing a button
                      Future.delayed(Duration(milliseconds: 500)).then(
                        (value) => Navigator.push(
                          context,
                          // route to second page
                          MaterialPageRoute(
                            builder: (context) => SecondPage(
                              ID: data.ID,
                              refresh: () => widget.refreshList(),
                            ),
                          ),
                        ),
                      );
                    } else {
                      Toast('Completed task cannot be edited');
                    }
                  },
                  // ----- end of animation section -------------------------------
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 12.0, right: 12.0),
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Container(
                        child: Column(
                          children: [
                            // ---- this is a top layer or title ---------------------------
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, top: 15.0, right: 15.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  data.title,
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.cabin(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            // ---- this is a middle layer --------------------------------
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ListTile(
                                    title: Text(
                                      'Start Date',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      timeFormatter(start),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: ListTile(
                                    title: Text(
                                      'End Date',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      timeFormatter(end),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: ListTile(
                                    title: Text(
                                      'Time Left',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      !data.isComplete
                                          ? t.calculate()
                                          : 'Complete',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            // ---- this is the bottom layer -----------------------------
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFe6e3d0),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: [
                                              TextSpan(text: 'Status  '),
                                              TextSpan(
                                                  text: data.isComplete
                                                      ? 'Complete'
                                                      : 'Incomplete',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: CheckboxListTile(
                                      key: UniqueKey(),
                                      value: data.isComplete,
                                      onChanged: (state) {
                                        widget.updateDatabase(data, state);
                                        setState(() {
                                          data.isComplete = state;
                                          print(data.isComplete);
                                        });
                                      },
                                      checkColor: Colors.white,
                                      activeColor: Colors.deepOrange,
                                      selectedTileColor: Colors.white,
                                      title: Text(
                                        'Tick if completed',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // ---- end of card content ----------------------------------------
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
        //if false
        : Center(
            child: Text('Add more To-Do-List'),
          );
  }
}
