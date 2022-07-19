import 'package:flutter/material.dart';
import 'package:nft_museum/pages/home_page.dart';
import 'package:nft_museum/pages/search_page.dart';
import 'screens/opening_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFTs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: "/starter",
      routes: {
        "/Home": (context) => const HomePage(),
        "/starter": (context) => const HomeScreen(),
        "/search": (context) => const SearchPage(),
      },
    );
  }
}
