import 'package:flutter/material.dart';
import 'package:repiceapp/HomeScreen.dart';
import 'package:repiceapp/MovieService.dart';
import 'package:repiceapp/MovieDetailScreen.dart'; // ✅ detay ekranı

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final results = await MovieService.searchMovies(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Film Ara")),
      body: Column(
        children: [
          // 🔎 Arama Kutusu
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Film adı yaz...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: _searchMovies,
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          Expanded(
            child: _searchResults.isEmpty
                ? const Center(child: Text("Film bulunamadı"))
                : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 75,
                    child: movie.poster.isNotEmpty
                        ? Image.network(
                      movie.poster, // ✅ poster zaten full URL HomeScreen Movie’den geliyor
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.movie),
                  ),
                  title: Text(movie.title),
                  subtitle: Text("IMDb: ${movie.rating}"),
                  onTap: () {
                    // ✅ Detay sayfasına git
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
