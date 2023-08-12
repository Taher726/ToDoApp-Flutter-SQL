import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb{

  static Database? _db;

  Future<Database?> get db async{
    if(_db == null){
      _db = await initialDb();
      return _db;
    }
    else{
      return _db;
    }
  }

  initialDb() async{
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, "todoapp.db");
    Database mydb = await openDatabase(path, onCreate: _onCreate, version: 1);
    return mydb;
  }

  _onCreate(Database db, int version) async{
    await db.execute('''
    CREATE TABLE "notes" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "name" TEXT NOT NULL,
      "is_completed" BIT DEFAULT 0,
      "task_date" TEXT NOT NULL,
      "priority" TEXT NOT NULL CHECK (priority IN ('High', 'Medium', 'Low'))
    )
    ''');
    print("Create DATABASE and Table");
  }


  readData(String sql) async{
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }
  insertData(String sql) async{
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }
  updateData(String sql) async{
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }
  deleteData(String sql) async{
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  mydeleteDb() async{
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'todoapp.db');
    await deleteDatabase(path);
  }
}