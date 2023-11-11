import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import Provider package
import '../db/databasehelper.dart';
import '../trip.dart';
import '../trip_provider.dart'; // Import your TripProvider

class MakePlanScreen extends StatefulWidget {
  const MakePlanScreen({Key? key}) : super(key: key);

  @override
  _MakePlanScreenState createState() => _MakePlanScreenState();
}

class _MakePlanScreenState extends State<MakePlanScreen> {
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _addTripDetails(BuildContext context) async {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);

    final TripDetails trip = TripDetails(
      departure: _departureController.text,
      destination: _destinationController.text,
      date: _selectedDate,
    );

    // Use the tripProvider to add the trip
    await tripProvider.addTrip(trip);

    // Clear input fields
    _departureController.clear();
    _destinationController.clear();

    // Show a snackbar to indicate that the trip has been added
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Trip added successfully.'),
      ),
    );
  }

  void _swapFields() {
    final String temp = _departureController.text;
    _departureController.text = _destinationController.text;
    _destinationController.text = temp;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make a Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _departureController,
                    decoration: const InputDecoration(
                      labelText: 'Departure Place',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz), // Interchange icon
                  onPressed: _swapFields,
                ),
                Flexible(
                  child: TextField(
                    controller: _destinationController,
                    decoration: const InputDecoration(
                      labelText: 'Destination Place',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.calendar_today), // Calendar icon
                  onPressed: () => _selectDate(context),
                ),
                const SizedBox(width: 8.0),
                Text(
                  DateFormat('dd-MM-yyyy').format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _addTripDetails(context),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
