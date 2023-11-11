import 'package:flutter/foundation.dart';
import 'package:travelapp/trip.dart'; // Import your Trip class
import '../db/databasehelper.dart'; // Import your database helper

class TripProvider with ChangeNotifier {
  List<TripDetails> _trips = [];

  List<TripDetails> get trips => _trips;

  // Load trips from the database
  Future<void> loadTrips() async {
    final List<TripDetails> loadedTrips = await TripDatabaseHelper().getTrips();
    _trips = loadedTrips;
    notifyListeners();
  }

  // Add a new trip
  Future<void> addTrip(TripDetails trip) async {
    final dbHelper = TripDatabaseHelper();
    final int id = await dbHelper.insertTrip(trip);
    if (id > 0) {
      trip.id = id;
      _trips.add(trip);
      notifyListeners();
    }
  }

  // Update an existing trip
  Future<void> updateTrip(TripDetails trip) async {
    final dbHelper = TripDatabaseHelper();
    final int updatedCount = await dbHelper.updateTrip(trip);
    if (updatedCount > 0) {
      final existingTripIndex = _trips.indexWhere((t) => t.id == trip.id);
      if (existingTripIndex != -1) {
        _trips[existingTripIndex] = trip;
        notifyListeners();
      }
    }
  }

  // Delete a trip
  Future<void> deleteTrip(TripDetails trip) async {
    final dbHelper = TripDatabaseHelper();
    final int deletedId = await dbHelper.deleteTrip(trip.id ?? -1);
    if (deletedId > 0) {
      _trips.removeWhere((t) => t.id == trip.id);
      notifyListeners();
    }
  }
}
