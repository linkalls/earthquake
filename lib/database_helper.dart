import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:async';
import 'models.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await setDB();
    return _db!;
  }

  DatabaseHelper.internal();

  setDB() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'earthquake.db');
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Earthquake(id INTEGER PRIMARY KEY, anm TEXT, rdt TEXT, mag TEXT)");
  }

  //insertion
  Future<int> saveEarthquake(Earthquake earthquake) async {
    var dbClient = await db;
    int res = await dbClient.insert("Earthquake", earthquake.toMap());
    return res;
  }

  //deletion
  Future<int> deleteEarthquake(Earthquake earthquake) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete('DELETE FROM Earthquake WHERE id = ?', [earthquake.id]);
    return res;
  }

  Future<List<Earthquake>> getEarthquakes() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Earthquake');
    List<Earthquake> earthquakes = [];
    for (int i = 0; i < list.length; i++) {
      var earthquake = Earthquake(
          id: list[i]["id"],
          anm: list[i]["anm"],
          rdt: list[i]["rdt"],
          mag: list[i]["mag"]);
      earthquakes.add(earthquake);
    }
    return earthquakes;
  }
}