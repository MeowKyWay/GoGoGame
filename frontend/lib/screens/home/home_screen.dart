import 'package:flutter/material.dart';
import 'package:gogogame_frontend/screens/home/home_page/home_page.dart';
import 'package:gogogame_frontend/screens/home/settings_page/settings_page.dart';
import 'package:gogogame_frontend/screens/home/record_page/record_page.dart';

abstract class AppHomePage extends Widget {
  const AppHomePage({super.key});

  Widget get title => const Text('Home');
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  final List<AppHomePage> _pages = [HomePage(), Record(), Store()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _pages[_currentIndex].title),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.play_circle), label: 'Play'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Records'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
    );
  }
}
