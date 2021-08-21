import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/Provider/MainProvider.dart';
import 'package:to_do_list_app/misc/BigDB.dart';
import 'package:to_do_list_app/misc/ItemList.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  //---------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    //check for item available in the list, if available, draw card with feature
    return Consumer<MainProvider>(
      builder: (_, provider, __) => provider.mList.length > 0
          //if true
          ? ListView.builder(
              itemCount: provider.mList.length,
              padding: EdgeInsets.only(bottom: 100.0),
              //The builder of list started here
              itemBuilder: (_, index) {
                DataModel data = provider.mList[index];
                return ItemList(
                  data: data,
                  onEdit: () {
                    setState(() {
                      provider.mList.removeAt(index);
                    });
                  },
                );
              })
          //if false
          : Center(
              child: Text('Add more To-Do-List'),
            ),
    );
  }
}
