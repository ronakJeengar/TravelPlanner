import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelapp/ItemScreen/homepage.dart';
import 'package:travelapp/ItemScreen/makeplan.dart';
import 'package:travelapp/ItemScreen/profile.dart';
import 'package:travelapp/ItemScreen/search.dart';
import 'package:travelapp/home.dart';
import 'package:travelapp/Otp.dart';
import 'package:travelapp/login.dart';
import 'package:travelapp/trip_provider.dart';

import 'ItemScreen/history.dart';
import 'itemExtraScreen/edit_profile_screen.dart';

void main() {
 // You should implement this function
  runApp(
    ChangeNotifierProvider(
      create: (context) => TripProvider(), // Provide the TripProvider
      child: const MyApp(), // Replace with your root widget
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // '/login': (context) => const LoginScreen(),
        // '/otp': (context) => const OtpScreen(),
        '/': (context) => const HomeScreen(),
        '/home': (context) => const HomePageScreen(),
        '/search': (context) => const SearchScreen(),
        '/makeplan': (context) => const MakePlanScreen(),
        '/history': (context) => const HistoryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit_profile_screen': (context) => const EditProfileScreen()
      },
    );
  }
}
