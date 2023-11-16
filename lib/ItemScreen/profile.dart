import 'package:flutter/material.dart';
import '../db/profile_database_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileDatabaseHelper _profileDbHelper = ProfileDatabaseHelper();

  late String _name = '';
  late String _email = '';
  late String _aboutMe = '';
  late String _location = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await _profileDbHelper.initDb();
    _profileDbHelper.profileChanges.listen((_) {
      _getProfileData();
    });
    _getProfileData();
  }

  Future<void> _getProfileData() async {
    final profile = await _profileDbHelper.getProfile();

    setState(() {
      _name = profile['name'] ?? '';
      _email = profile['email'] ?? '';
      _aboutMe = profile['aboutMe'] ?? '';
      _location = profile['location'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4AC5FF), Color(0xFF0099FF)],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: const AssetImage('assets/images/profile_image.jpg'),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  _name,
                  style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 8.0),
                Text(
                  _email,
                  style: const TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
                const SizedBox(height: 24.0),
                Divider(color: Colors.grey),
                const SizedBox(height: 24.0),
                Text(
                  'About Me:',
                  style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  _aboutMe,
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 24.0),
                Divider(color: Colors.grey),
                const SizedBox(height: 24.0),
                Text(
                  'Location:',
                  style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  _location,
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/edit_profile_screen');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0099FF),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
