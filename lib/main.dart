import 'package:flutter/material.dart';
import 'package:smartClockFinal/alarm/alarm_page.dart';
import 'package:smartClockFinal/clock_page.dart';
import 'package:smartClockFinal/rooms.dart';
import 'package:smartClockFinal/news_page.dart';
import 'package:smartClockFinal/task/automated_task_page.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Alarm',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    Rooms(),
    TaskPage(),
    AlarmPage(),
    NewsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.lock_clock), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "Alarm"),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), label: "News"),
        ],
        currentIndex: _selectedIndex,
        // backgroundColor: Color(0xff21222b),
        backgroundColor: Color(0xff151517),
        unselectedItemColor: Color(0xff565970),
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
