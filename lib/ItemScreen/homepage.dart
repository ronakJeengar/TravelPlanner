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
          if (upcomingTrips.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Upcoming Trip',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (upcomingTrips.isNotEmpty)
            SizedBox(
              height: 200.0, // Set the desired height for the horizontal list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: upcomingTrips.length,
                itemBuilder: (context, index) {
                  return UpcomingTripCard(trip: upcomingTrips[index]);
                },
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
      margin: const EdgeInsets.fromLTRB(2.0, 23.0, 2.0, 23.0), // Set different margins here
      constraints: const BoxConstraints(maxWidth: 400.0), // Set a maximum width
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // Adjust border radius as needed
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Departure',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Destination',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.trip.departure,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    widget.trip.destination,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Text(
                    'Remaining Days: $remainingDays',
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Countdown: $countdownText',
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
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
