import 'package:btech/Home/admin/adminF.dart';
import 'package:btech/Home/admin/adminS.dart';
import 'package:btech/Home/widgets/appbar.dart';
import 'package:btech/Log/register.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = [
    AdminS(),
    AdminF(),
    Register(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 247, 247, 247),
          appBar: appBar('Admin', context),
          body: TabBarView(
            children: [_widgetOptions.elementAt(_selectedIndex)],
          ),
          bottomNavigationBar: btmNav(),
        ));
  }

  btmNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amberAccent,
      unselectedItemColor: Colors.black,
      backgroundColor: Colors.white,
      onTap: _onItemTapped,
      selectedFontSize: 15,
      selectedLabelStyle: TextStyle(fontFamily: 'Indie'),
      selectedIconTheme: IconThemeData(size: 30, grade: 20),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'البيانات',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_search),
          label: 'السائقين',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_add),
          label: 'تسجيل السائق',
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}
