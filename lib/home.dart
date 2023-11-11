import 'package:flutter/material.dart';
import 'ItemScreen/history.dart';
import 'ItemScreen/homepage.dart';
import 'ItemScreen/profile.dart';
import 'ItemScreen/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<BarItem> _barItems = [
    const BarItem(icon: Icons.home, title: 'Home'),
    const BarItem(icon: Icons.search, title: 'Search'),
    const BarItem(icon: Icons.history, title: 'History'),
    const BarItem(icon: Icons.person, title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_barItems[_currentIndex].title), // Set the title based on the selected index
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomePageScreen(),
          SearchScreen(),
          HistoryScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: _barItems
            .asMap()
            .map((index, item) {
          return MapEntry(
            index,
            BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.title,
            ),
          );
        })
            .values
            .toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/makeplan');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BarItem {
  final IconData icon;
  final String title;

  const BarItem({required this.icon, required this.title});
}
