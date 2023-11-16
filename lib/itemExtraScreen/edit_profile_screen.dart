import 'package:flutter/material.dart';
import '../db/profile_database_helper.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileDatabaseHelper _profileDbHelper = ProfileDatabaseHelper();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _aboutMeController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await _profileDbHelper.initDb();
    final profile = await _profileDbHelper.getProfile();

    setState(() {
      _nameController.text = profile['name'] ?? '';
      _emailController.text = profile['email'] ?? '';
      _aboutMeController.text = profile['aboutMe'] ?? '';
      _locationController.text = profile['location'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 180.0,
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/images/profile_image.jpg'),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _aboutMeController,
              decoration: const InputDecoration(
                labelText: 'About Me',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _profileDbHelper.updateProfile({
                  'name': _nameController.text,
                  'email': _emailController.text,
                  'aboutMe': _aboutMeController.text,
                  'location': _locationController.text,
                });

                // Reload the profile on the ProfileScreen
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12.0),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
