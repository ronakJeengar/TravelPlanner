class TripDetails {
  int? id;
  String departure;
  String destination;
  DateTime date;

  TripDetails({
    this.id,
    required this.departure,
    required this.destination,
    required this.date,
  });

  // Create a TripDetails instance from a map
  TripDetails.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        departure = map['departure'],
        destination = map['destination'],
        date = DateTime.parse(map['date']);

  // Convert a TripDetails instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'departure': departure,
      'destination': destination,
      'date': date.toIso8601String(),
    };
  }

  // Create a copy of a TripDetails instance
  TripDetails.copy(TripDetails other)
      : id = other.id,
        departure = other.departure,
        destination = other.destination,
        date = other.date;
}
