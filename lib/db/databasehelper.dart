import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:travelapp/trip.dart'; // Import your Trip class

class TripDatabaseHelper {
  static final TripDatabaseHelper _instance = TripDatabaseHelper.internal();

  factory TripDatabaseHelper() => _instance;

  TripDatabaseHelper.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'trip_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE trips (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        departure TEXT,
        destination TEXT,
        date TEXT
      )
    ''');
  }

  Future<int> insertTrip(TripDetails trip) async {
    final dbClient = await db;
    final id = await dbClient.insert('trips', trip.toMap());
    return id;
  }

  Future<List<TripDetails>> getTrips() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('trips');
    return List.generate(maps.length, (i) {
      return TripDetails.fromMap(maps[i]);
    });
  }

  Future<int> updateTrip(TripDetails trip) async {
    final dbClient = await db;
    return await dbClient.update(
      'trips',
      trip.toMap(),
      where: 'id = ?',
      whereArgs: [trip.id],
    );
  }

  Future<int> deleteTrip(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'trips',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
