import 'package:flutter/material.dart';
import 'package:travelapp/trip.dart'; // Import your TripDetails class
import '../db/databasehelper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<TripDetails> searchResults = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _searchTrips(String query) async {
    final trips = await TripDatabaseHelper().getTrips();

    // Example: Simple search based on departure or destination containing the query
    final results = trips.where((trip) =>
    trip.departure.toLowerCase().contains(query.toLowerCase()) ||
        trip.destination.toLowerCase().contains(query.toLowerCase()));

    setState(() {
      searchResults = results.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                _searchTrips(query);
              },
              decoration: const InputDecoration(
                labelText: 'Search Trips',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final trip = searchResults[index];
                return ListTile(
                  title: Text('Departure: ${trip.departure}'),
                  subtitle: Text('Destination: ${trip.destination}'),
                  // You can customize the display based on your requirements
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
