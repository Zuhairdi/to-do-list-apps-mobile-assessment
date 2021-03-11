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
  add({String title, int startDate, int endDate, bool isComplete}) async {
    int _isComplete = 0;
    if (isComplete) _isComplete = 1;
    try {
      await database.transaction((txn) async {
        await txn.rawInsert(
            'INSERT INTO $databaseName (title, start, end, isComplete) VALUES ("$title", $startDate, $endDate, $_isComplete)');
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  //use this function to update existing entries
  update(
      {int ID,
      String title,
      int startDate,
      int endDate,
      bool isComplete}) async {
    int _isComplete = 0;
    if (isComplete) _isComplete = 1;
    try {
      await database.transaction((txn) async {
        await txn.rawInsert(
            'UPDATE $databaseName SET title = "$title", start = $startDate, end = $endDate, isComplete = $_isComplete WHERE id = $ID');
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  //call this function to get the list of value
  Future<List<BigDBHandler>> read() async {
    List<BigDBHandler> mList = List<BigDBHandler>.empty(growable: true);
    try {
      await database
          .rawQuery('SELECT * FROM $databaseName ORDER BY isComplete, end ASC')
          .then((value) {
        for (var data in value) {
          BigDBHandler handler = BigDBHandler();
          handler.get(data);
          mList.add(handler);
        }
      });
    } on Exception catch (e) {
      print(e.toString());
    }
    return mList;
  }

  Future<BigDBHandler> readSingle(int ID) async {
    BigDBHandler handler = BigDBHandler();
    try {
      await database
          .rawQuery('SELECT * FROM $databaseName WHERE id = $ID')
          .then((value) {
        handler.get(value.first);
      });
    } on Exception catch (e) {
      print(e.toString());
    }
    return handler;
  }

  //delete the entries in the database
  Future<int> delete(int ID) async {
    try {
      return await database
          .rawDelete('DELETE FROM $databaseName WHERE id = $ID');
    } on Exception catch (e) {
      print(e.toString());
    }
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

class BigDBHandler {
  int ID;
  String title;
  int startDate;
  int endDate;
  bool isComplete;

  get(data) {
    int temp = data['isComplete'];
    ID = data['id'];
    title = data['title'];
    startDate = data['start'];
    endDate = data['end'];
    isComplete = temp > 0 ? true : false;
  }
}
