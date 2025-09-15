import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:repiceapp/Login.dart';
import 'package:repiceapp/ProfileScreen.dart';
import 'package:repiceapp/FavoritesScreen.dart';
import 'package:repiceapp/HomeScreen.dart';
import 'package:repiceapp/SearchScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film Uygulaması',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Login(), // ilk açılışta Login ekranı
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedItem = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // SADECE ANA SAYFADA GÖRÜNECEK
          if (selectedItem == 0) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 46.0, vertical: 12.0),
              child: Column(
                children: [
                  const SizedBox(width: 12),
                  Text(
                    "Merhaba ${FirebaseAuth.instance.currentUser?.displayName ?? "Kullanıcı"} 👋",
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
    Text(
   " 🎬 “Bugün film keşfetmeye hazır mısın?",

    style: const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    ),
    ),
                ],
              ),
            ),

          ],

          // HER ZAMAN SAYFA İÇERİĞİ
          Expanded(
            child: pages[selectedItem],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedItem,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Arama',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoriler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilim',
          ),
        ],
      ),
    );
  }
}
