import 'package:flutter/material.dart';
import 'package:travelapp/trip.dart'; // Import your TripDetails class
import '../db/databasehelper.dart';
import 'dart:async';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<TripDetails> upcomingTrips = [];

  @override
  void initState() {
    super.initState();
    loadUpcomingTrips();
  }

  Future<void> loadUpcomingTrips() async {
    final trips = await TripDatabaseHelper().getTrips();
    final now = DateTime.now();

    // Filter trips that are nearing (within 4 days)
    final upcoming = trips.where((trip) {
      final daysUntilTrip = trip.date.difference(now).inDays;
      return daysUntilTrip <= 4 && daysUntilTrip >= 0;
    }).toList();

    setState(() {
      upcomingTrips = upcoming;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 16.0),
          if (upcomingTrips.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Upcoming Trips',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (upcomingTrips.isNotEmpty)
            SizedBox(
              height: 235.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: upcomingTrips.length,
                itemBuilder: (context, index) {
                  return UpcomingTripCard(trip: upcomingTrips[index]);
                },
              ),
            ),
          if (upcomingTrips.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'No upcoming trips.',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class UpcomingTripCard extends StatefulWidget {
  final TripDetails trip;

  const UpcomingTripCard({Key? key, required this.trip}) : super(key: key);

  @override
  _UpcomingTripCardState createState() => _UpcomingTripCardState();
}

class _UpcomingTripCardState extends State<UpcomingTripCard> {
  late int remainingDays;
  String countdownText = '';
  late Timer countdownTimer;

  @override
  void initState() {
    super.initState();
    calculateRemainingDays();
    startCountdownTimer();
  }

  void calculateRemainingDays() {
    final now = DateTime.now();
    final daysUntilTrip = widget.trip.date.difference(now).inDays;
    remainingDays = daysUntilTrip;
  }

  void startCountdownTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final duration = widget.trip.date.difference(now);

      if (duration.isNegative) {
        timer.cancel();
        setState(() {
          countdownText = 'Trip ended';
        });
      } else {
        final days = duration.inDays;
        final hours = duration.inHours.remainder(24);
        final minutes = duration.inMinutes.remainder(60);
        final seconds = duration.inSeconds.remainder(60);
        setState(() {
          countdownText =
          '$days days $hours hours $minutes minutes $seconds seconds';
        });
      }
    });
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      constraints: const BoxConstraints(maxWidth: 300.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Departure: ${widget.trip.departure}',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Destination: ${widget.trip.destination}',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Remaining Days: $remainingDays',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                'Countdown: $countdownText',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add logic to view trip details
                    },
                    child: const Text('View Details'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add logic to edit trip details
                    },
                    child: const Text('Edit Trip'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
