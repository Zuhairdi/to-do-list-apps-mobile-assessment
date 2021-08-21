import 'package:flutter/material.dart';
import 'package:to_do_list_app/misc/BigDB.dart';

class MainProvider extends ChangeNotifier {
  List<DataModel> _mList = [];
  BigDB _bigDB;
  AnimationController _animationController;

  AnimationController get animationController => _animationController;

  set animationController(AnimationController value) {
    _animationController = value;
    notifyListeners();
  }

  deleteTask(DataModel data) async {
    await bigDB.delete(data.id);
    updateList();
  }

  updateCheck(DataModel data, bool check) async {
    data.isComplete = check;
    await bigDB.update(dataModel: data);
    updateList();
  }

  updateList() async {
    mList.clear();
    mList = await bigDB.read();
    notifyListeners();
  }

  List<DataModel> get mList => _mList;

  set mList(List<DataModel> value) {
    _mList = value;
    notifyListeners();
  }

  BigDB get bigDB => _bigDB;

  set bigDB(BigDB value) {
    _bigDB = value;
    notifyListeners();
  }
}
