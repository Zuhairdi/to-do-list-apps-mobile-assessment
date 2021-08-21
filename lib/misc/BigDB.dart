import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/*
*   This is a SQL helper to help in all activities involving database.
*/

class BigDB {
  String databaseName;
  Database database;
  //open the database file
  //initialize database - to be called during initState
  init(String dbName) async {
    databaseName = dbName;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$dbName.db');
    try {
      database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table if the table does not exists
        await db.execute(
            'CREATE TABLE IF NOT EXISTS  $dbName (id INTEGER PRIMARY KEY, title TEXT, start INT, end INT, isComplete INT)');
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  //use this function to add entries to the database
  add({DataModel dataModel}) async {
    try {
      await database.transaction((txn) async {
        await txn.rawInsert(
            'INSERT INTO $databaseName (title, start, end, isComplete) VALUES ("${dataModel.title}", ${dataModel.startDate}, ${dataModel.endDate}, ${dataModel.isComplete ? 1 : 0})');
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  //use this function to update existing entries
  update({DataModel dataModel}) async {
    try {
      await database.transaction((txn) async {
        await txn.rawInsert(
            'UPDATE $databaseName SET title = "${dataModel.title}", start = ${dataModel.startDate}, end = ${dataModel.endDate}, isComplete = ${dataModel.isComplete ? 1 : 0} WHERE id = ${dataModel.id}');
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  //call this function to get the list of value
  Future<List<DataModel>> read() async {
    List<DataModel> mList = [];
    try {
      var value = await database
          .rawQuery('SELECT * FROM $databaseName ORDER BY isComplete, end ASC');
      for (var data in value) {
        DataModel handler = DataModel();
        handler.get(data);
        mList.add(handler);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return mList;
  }

  Future<DataModel> readSingle(int id) async {
    DataModel handler = DataModel();
    try {
      await database
          .rawQuery('SELECT * FROM $databaseName WHERE id = $id')
          .then((value) {
        handler.get(value.first);
      });
    } on Exception catch (e) {
      print(e.toString());
    }
    return handler;
  }

  //delete the entries in the database
  Future<int> delete(int id) async {
    try {
      return await database
          .rawDelete('DELETE FROM $databaseName WHERE id = $id');
    } on Exception catch (e) {
      print(e.toString());
    }
    return -1;
  }

  //drop table - fully delete the database *carefull
  deleteDatabase() async {
    try {
      return await database.delete(databaseName);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  //close the database - to be called during dispose
  closeDatabase() async => await database.close();
}

class DataModel {
  int id;
  String title;
  int startDate;
  int endDate;
  bool isComplete;

  DataModel({
    this.id,
    this.title,
    this.startDate,
    this.endDate,
    this.isComplete,
  });

  get(data) {
    int temp = data['isComplete'];
    id = data['id'];
    title = data['title'];
    startDate = data['start'];
    endDate = data['end'];
    isComplete = temp > 0 ? true : false;
  }
}
