import 'package:flutter/material.dart';
import 'Asset.dart';
import 'BlockList.dart';

class FrameMenu extends StatefulWidget {
  const FrameMenu({Key? key}) : super(key: key);

  @override
  _FrameMenuState createState() => _FrameMenuState();
}

class _FrameMenuState extends State<FrameMenu> {
  int _currentIndex = 0;

  final List<Widget> _pageList = [AssetPage(), Block_ListPage()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pageList,
          ),
          Text(" "),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 3,
        backgroundColor: Color.fromARGB(255, 237, 235, 235),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        fixedColor: Colors.blue, //what color is selected
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.currency_bitcoin), label: ("Asset")),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_tree), label: ("Block"))
        ],
      ),
    );
  }
}
