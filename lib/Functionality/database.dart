import 'dart:io';

import 'package:newsapp/Decode/data.dart';
import 'package:newsapp/Pages/Saved.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  static final _databaseName = "saved.db";
  static final _databaseVersion = 1;

  static final table = 'saved';
  static final columnId = '_id';
  static final url = 'url';
  static final urltoimg = 'urlToImage';
  static final title = 'title';

  // Singelton Class
  DatabaseHelper._instance();
  static final DatabaseHelper instance = DatabaseHelper._instance();

  static Database _database;

  Future<Database> get database async{
    if(_database != null){
      return _database;
    }
    else{
      return _database = await _initDatabase();
    }
  }

  _initDatabase() async{
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + _databaseName;

    return await openDatabase(path,version: _databaseVersion,onCreate: _onCreate);
  }

  // Creatin DB
  Future _onCreate(Database db,int version) async{
    print("DB Created");
    return db.execute('''
          CREATE TABLE $table (
            $url TEXT PRIMARY KEY,
            $title TEXT NOT NULL,
            $urltoimg TEXT NULLABLE
          )
          ''');
  }

  // Insert to DB
  Future<int> insert(Data data) async {
    print("Inserted");
    Database db = await instance.database;
    return await db.insert(table, data.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all from DB
  Future<List<Data>> queryAllRows() async {
    Database db = await instance.database;

    final List<Map<String, dynamic>> result = await db.query(table);

    if(result.length != 0){
      return List.generate(result.length, (i){
        return Data(
          url: result[i]['url'],
          title: result[i]['title'],
          urltoimg: result[i]['urlToImage']
        );
      });
    }
    else {
      return null;
    }
  }

  // Delete from DB
  Future<void> delete(String url) async{
    Database db = await instance.database;
    await db.delete(table,where: "url = ?",whereArgs: [url]);
    print("Deleted from DB");
  }
  
}