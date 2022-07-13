import 'package:flutter/material.dart';
import 'package:nft_museum/widgets/intro_widget.dart';
import 'package:nft_museum/widgets/top_collections.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  late Widget currentBody;

  @override
  void initState() {
    super.initState();
    currentBody = const HomePageHome();
  }

  void setBody(int i) {
    switch (i) {
      case 0:
        currentBody = const HomePageHome();
        break;
      case 1:
        currentBody = const HomePageSearch();
        break;
      case 2:
        currentBody = const HomePageFavorite();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: currentBody,
        // extendBody: true,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: Colors.white,
          onTap: (index) {
            setState(() {
              currentIndex = index;
              setBody(index);
            });
          },
          backgroundColor: Colors.black.withOpacity(0.8),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              label: 'Favorite',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePageHome extends StatefulWidget {
  const HomePageHome({Key? key}) : super(key: key);

  @override
  State<HomePageHome> createState() => _HomePageHomeState();
}

class _HomePageHomeState extends State<HomePageHome> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const <Widget>[
          IntroWidget(),
          SizedBox(height: 10),
          TopCollections(),
        ],
      ),
    );
  }
}

class HomePageSearch extends StatefulWidget {
  const HomePageSearch({Key? key}) : super(key: key);

  @override
  State<HomePageSearch> createState() => _HomePageSearchState();
}

class _HomePageSearchState extends State<HomePageSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text("To Be Done"),
      ),
    );
  }
}

class HomePageFavorite extends StatefulWidget {
  const HomePageFavorite({Key? key}) : super(key: key);

  @override
  State<HomePageFavorite> createState() => _HomePageFavoriteState();
}

class _HomePageFavoriteState extends State<HomePageFavorite> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text("To Be Done"),
      ),
    );
  }
}
