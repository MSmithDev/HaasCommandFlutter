import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String machineDataTable = 'machinedata';
final String columnSn = '_id';
final String columnNickname = 'nickname';
final String columnConnectionName = 'host';
final String columnPort = 'port';
final String columnModel = 'model';
final String columnSoftwareVersion = 'software';

// data model class
class MachineData {
  int sn;
  String nickname;
  String connectionName;
  int port;
  String model;
  String softwareVersion;

  MachineData();

  // convenience constructor to create a Word object
  MachineData.fromMap(Map<String, dynamic> map) {
    sn = map[columnSn];
    nickname = map[columnNickname];
    connectionName = map[columnConnectionName];
    port = map[columnPort];
    model = map[columnModel];
    softwareVersion = map[columnSoftwareVersion];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnSn: sn,
      columnNickname: nickname,
      columnConnectionName: connectionName,
      columnPort: port,
      columnModel: model,
      columnSoftwareVersion: softwareVersion
    };
    if (sn != null) {
      map[columnSn] = sn;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "HaasCommand.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $machineDataTable (
                $columnSn INTEGER PRIMARY KEY,
                $columnNickname TEXT NOT NULL,
                $columnConnectionName TEXT NOT NULL,
                $columnPort INTEGER NOT NULL,
                $columnModel TEXT NOT NULL,
                $columnSoftwareVersion TEXT NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insertMachineData(MachineData data) async {
    Database db = await database;
    int id = 0;

    try {
      print('attempting db write');
      id = await db.insert(machineDataTable, data.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Database error $e');
    }

    return id;
  }

  Future<MachineData> queryMachineData(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(machineDataTable,
        columns: [
          columnSn,
          columnNickname,
          columnConnectionName,
          columnPort,
          columnModel,
          columnSoftwareVersion
        ],
        where: '$columnSn = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return MachineData.fromMap(maps.first);
    }
    return null;
  }

  Future<List<MachineData>> queryAllMachines() async {
    Database db = await database;
    List<Map> maps = await db.query(machineDataTable);
    if (maps.length > 0) {
      List<MachineData> md = [];
      maps.forEach((map) => md.add(MachineData.fromMap(map)));
      return md;
    }
    return null;
  }

  Future<int> removeMachine(MachineData md) async {
    Database db = await database;
    print('removing ${md}');
    return await db
        .delete(machineDataTable, where: '$columnSn = ?', whereArgs: [md.sn]);
  }

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}
