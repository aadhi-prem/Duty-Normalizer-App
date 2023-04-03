import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:untitled8/sql_lite_services.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;
class LocalDB{

  static Database? _database;
  Future<Database> get dataBase async {
    if (_database == null) {
     // print("fkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk uuuuuuuuuuuuuuuuuuuuu");
      _database = await initializeDataBase();
    }
    return _database!;
  }

  Future<Database> initializeDataBase() async {
    print("hello");
    String dir = await getDatabasesPath();
    print(dir);
    String p = dir + 'database.db';
    bool dbexists=await io.File(p).exists();
    Database db = await openDatabase(p);
    if(!dbexists) {
      ByteData data = await rootBundle.load(path.join("assets", "database.db"));
      List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);
      await io.File(p).writeAsBytes(bytes, flush: true);
      db = await openDatabase(p);
//     Database db =
//     await openDatabase(path, version: 1, onCreate: (db, version) async {
//       await db.execute('''
//       CREATE Table Mtech(
//     RollNo VARCHAR(10) NOT NULL,
//     Name VARCHAR(30) NOT NULL,
//     DEPARTMENT VARCHAR(50) Not NULL,
//     PhoneNo VARCHAR(20),
//     Email VARCHAR(50) NOT NULL,
//     WorkHours INT NOT NULL,
//     Status varchar(10) NOT NULL,
//     PRIMARY KEY(RollNo)
// );
//
//       ''');
//     });
    }
    return db;
  }
  Future<List<Map<String,dynamic>>> readDB(String s) async {


    Database db = await this.dataBase;
    List<Map<String,dynamic>> _ak = await db.rawQuery(s);
    return _ak;
  }

  Future<void> executeDB(String s) async {
    Database db = await this.dataBase;
    await db.rawQuery(s);
  }
  Future<Database>givedb() async{
    Database db= await this.dataBase;
    return db;
  }

  Future<void> writeDB( Map<String, dynamic> a,String s) async {
    Database db = await this.dataBase;
    try {
      await db.insert(
         s,
        {
          'Rollno': a['Rollnumber'],
          'Name': a['Name'],
          'DEPARTMENT': a['Department'],
          'PhoneNo': a['PhoneNo'],
          'Email': a['Email'],
          'WorkHours': 0,
          'Status': 'unblocked',
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      debugPrint('Data Inserted Successfully.');
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }

  }
}