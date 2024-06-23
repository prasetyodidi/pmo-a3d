
import 'package:a3d/constants/index.dart';
import 'package:a3d/screens/CartListScreen.dart';
import 'package:a3d/screens/HistorySaleScreen.dart';
import 'package:a3d/screens/ProductListScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  final int initialIndex;

  const Navbar({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late int _selectedIndex;

  static const List<Widget> _widgetOptions = <Widget>[
    ProductListScreen(),
    CartListScreen(),
    HistorySaleScreen(),
    ProductListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Block the back button press
        return false;
      },
      child: Scaffold(
        backgroundColor: WHITE,
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.bag_fill),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.cart),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chart_bar_circle_fill),
                label: 'Search',
              ),
               BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.profile_circled),
                label: 'Search',
              ),
            ],
            currentIndex: _selectedIndex,
            elevation: 0,
            backgroundColor: WHITE,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.black.withOpacity(0.3),
            onTap: _onItemTapped,
            showSelectedLabels: false,
            iconSize: 27,

            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
