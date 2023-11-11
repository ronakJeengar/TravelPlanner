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
      // appBar: AppBar(
      //   title: const Text('Profile'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile_image.jpg'),
              // Add your profile image
            ),
            const SizedBox(height: 16.0),
            Text(
              'Name: $_name',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Email: $_email',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'About Me: $_aboutMe',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Location: $_location',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/edit_profile_screen');
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
