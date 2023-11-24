import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelapp/trip.dart';
import '../db/databasehelper.dart';
import 'package:provider/provider.dart';
import '../trip_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Consumer<TripProvider>(
        builder: (context, tripProvider, child) {
          return tripProvider.trips.isEmpty
              ? const Center(child: Text('No trips found.'))
              : ListView.builder(
            itemCount: tripProvider.trips.length,
            itemBuilder: (context, index) {
              final trip = tripProvider.trips[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 5.0),
                elevation: 3,
                color: Colors.white70,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Departure: ${trip.departure}'),
                      Text('Destination: ${trip.destination}'),
                      Text(
                        'Date: ${DateFormat('dd-MM-yyyy').format(trip.date)}',
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editTripDetails(context, trip);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteTrip(context, trip);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteTrip(BuildContext context, TripDetails trip) async {
    final dbHelper = TripDatabaseHelper();
    final int deletedId = await dbHelper.deleteTrip(trip.id ?? -1);

    if (deletedId > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip deleted successfully.'),
        ),
      );
      Provider.of<TripProvider>(context, listen: false)
          .loadTrips(); // Reload the list of trips
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete the trip.'),
        ),
      );
    }
  }

  void _editTripDetails(BuildContext context, TripDetails trip) async {
    final dbHelper = TripDatabaseHelper();

    // Initialize editedTrip with a copy of the provided trip
    TripDetails editedTrip = TripDetails.copy(trip);

    final TripDetails? updatedTrip = await showDialog<TripDetails>(
      context: context,
      builder: (context) {
        final TextEditingController departureController =
        TextEditingController(text: editedTrip.departure);
        final TextEditingController destinationController =
        TextEditingController(text: editedTrip.destination);
        DateTime selectedDate = editedTrip.date;

        return AlertDialog(
          title: const Text('Edit Trip Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: departureController,
                decoration: const InputDecoration(labelText: 'Departure Place'),
                onChanged: (text) {
                  editedTrip.departure = text;
                },
              ),
              TextField(
                controller: destinationController,
                decoration:
                const InputDecoration(labelText: 'Destination Place'),
                onChanged: (text) {
                  editedTrip.destination = text;
                },
              ),
              Row(
                children: [
                  Text(
                      'Date: ${DateFormat('dd-MM-yyyy').format(selectedDate)}'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate =
                              picked; // Update the selectedDate immediately
                          editedTrip.date =
                              picked; // Also update the date in the editedTrip
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await dbHelper.updateTrip(editedTrip);
                Navigator.of(context).pop(editedTrip);
                Provider.of<TripProvider>(context, listen: false)
                    .loadTrips(); // Update the list of trips
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (updatedTrip != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip details updated successfully.'),
        ),
      );
    }
  }
}