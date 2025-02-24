import 'package:flutter/material.dart';
import 'package:gogogame_frontend/screens/home/home_page/home_page.dart';
import 'package:gogogame_frontend/screens/home/more_page/more_page.dart';
import 'package:gogogame_frontend/screens/home/store_page/store_page.dart';

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

  final List<AppHomePage> _pages = [HomePage(), StorePage(), MorePage()];

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
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Store',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
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
