import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MovieService.dart';
import 'MovieDetailScreen.dart'; // ✅ detay ekranı

class Movie {
  final String title;
  final String poster;
  final double rating;
  final String overview;

  Movie({
    required this.title,
    required this.poster,
    required this.rating,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? "Bilinmeyen",
      poster: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500${json['poster_path']}"
          : "https://via.placeholder.com/300x450?text=Poster+Yok",
      rating: (json['vote_average'] ?? 0).toDouble(),
      overview: json['overview'] ?? "Özet bulunamadı.",
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  Timer? _autoPlayTimer;
  late Future<List<Movie>> futureMovies;

  final List<String> favorites = [];
  final User? user = FirebaseAuth.instance.currentUser;

  String selectedCategory = "Tümü"; // ✅ kategori seçili

  final List<Movie> featured = [
    Movie(
      title: "Inception",
      poster: "https://urladam.com.tr/wp-content/uploads/2025/02/inception.jpg",
      rating: 7.8,
      overview: "Bir adam rüyalarda bilinçaltını manipüle eder.",
    ),
    Movie(
      title: "Çizgi Pijamalı Çocuk",
      poster:
      "https://img.fullhdfilmizlesene.tv/cover/izle/cizgili-pijamali-cocuk-fh3-2589.jpg",
      rating: 8.1,
      overview: "İkinci Dünya Savaşı döneminde geçen bir dostluk hikayesi.",
    ),
    Movie(
      title: "10 Günde Bir Erkek Nasıl Kaybedilir",
      poster:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfhiGoi-Fz-AHHAFbesg17koXK7w9nDnjRRg&s",
      rating: 7.2,
      overview: "Romantik-komedi türünde eğlenceli bir film.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
    futureMovies = MovieService.fetchMovies() as Future<List<Movie>>; // ✅ başlangıçta popüler
    _loadFavorites();

    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });
  }

  Future<void> _loadFavorites() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .collection("favorites")
        .get();

    setState(() {
      favorites.clear();
      favorites.addAll(snapshot.docs.map((doc) => doc.id));
    });
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients) {
        int next = (_currentPage + 1) % featured.length;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // ✅ kategori değiştir
  void _changeCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category == "Tümü") {
        futureMovies = MovieService.fetchMovies() as Future<List<Movie>>;
      } else if (category == "Komedi") {
        futureMovies = MovieService.fetchMoviesByGenre(35) as Future<List<Movie>>;
      } else if (category == "Aksiyon") {
        futureMovies = MovieService.fetchMoviesByGenre(28) as Future<List<Movie>>;
      } else if (category == "Dram") {
        futureMovies = MovieService.fetchMoviesByGenre(18) as Future<List<Movie>>;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = user?.displayName ?? "Kullanıcı";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 6),
            const Text(
              "⭐ Bugünün Öne Çıkanları",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 🎬 Carousel
            SizedBox(
              height: 280,
              child: PageView.builder(
                controller: _pageController,
                itemCount: featured.length,
                itemBuilder: (context, index) {
                  final movie = featured[index];
                  final bool active = index == _currentPage;
                  return _buildCarouselItem(movie, active);
                },
              ),
            ),
            _buildDots(),

            // 📌 Kategoriler
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Kategoriler",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip("Tümü"),
                    _buildCategoryChip("Komedi"),
                    _buildCategoryChip("Aksiyon"),
                    _buildCategoryChip("Dram"),
                  ],
                ),
              ),
            ),

            // 🔽 API'den Popüler / Kategoriye göre Filmler (Grid)
            Expanded(
              child: FutureBuilder<List<Movie>>(
                future: futureMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Hata: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Film bulunamadı"));
                  }

                  final movies = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      final isFavorite = favorites.contains(movie.title);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailScreen(
                                title: movie.title,
                                poster: movie.poster,
                                rating: movie.rating,
                                overview: movie.overview,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          clipBehavior: Clip.hardEdge,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  movie.poster,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                    WidgetStateProperty.all(Colors.black45),
                                    padding: WidgetStateProperty.all(
                                        EdgeInsets.zero),
                                  ),
                                  onPressed: () async {
                                    final currentUser =
                                        FirebaseAuth.instance.currentUser;
                                    if (currentUser == null) return;

                                    final docRef = FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(currentUser.uid)
                                        .collection("favorites")
                                        .doc(movie.title);

                                    if (isFavorite) {
                                      await docRef.delete();
                                      setState(() {
                                        favorites.remove(movie.title);
                                      });
                                    } else {
                                      await docRef.set({
                                        "title": movie.title,
                                        "poster": movie.poster,
                                        "rating": movie.rating,
                                        "overview": movie.overview,
                                      });
                                      setState(() {
                                        favorites.add(movie.title);
                                      });
                                    }
                                  },
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.0),
                                        Colors.black.withOpacity(0.7),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        movie.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        movie.overview,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "⭐ ${movie.rating.toStringAsFixed(1)}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Carousel item
  Widget _buildCarouselItem(Movie movie, bool active) {
    final double margin = active ? 8 : 14;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: EdgeInsets.symmetric(horizontal: margin, vertical: margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(movie.poster, fit: BoxFit.cover),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 100,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.75),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.overview,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Nokta göstergesi
  Widget _buildDots() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(featured.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: i == _currentPage ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == _currentPage ? Colors.blue : Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ✅ Kategori Chip
  Widget _buildCategoryChip(String title) {
    final bool isSelected = selectedCategory == title;
    return GestureDetector(
      onTap: () => _changeCategory(title),
      child: Container(
        margin: const EdgeInsets.only(left: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
