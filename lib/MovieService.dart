import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repiceapp/HomeScreen.dart'; // Movie modelini kullanmak için

class MovieService {
  static const String apiKey = "cd C:\Users\yldrm\StudioProjects\RepiceApp";
  static const String baseUrl = "https://api.themoviedb.org/3";

  // 📌 Popüler filmleri getir
  static Future<List<Movie>> fetchMovies() async {
    final url = Uri.parse("$baseUrl/movie/popular?api_key=$apiKey&language=tr-TR");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception("API'den veri alınamadı: ${response.statusCode}");
    }
  }

  // 🔍 Arama: İsme göre film getir
  static Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse(
      "$baseUrl/search/movie?api_key=$apiKey&query=$query&language=tr-TR",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception("Film arama başarısız: ${response.statusCode}");
    }
  }

  // 🎭 Kategoriye göre film getir
  static Future<List<Movie>> fetchMoviesByGenre(int genreId) async {
    final url = Uri.parse(
      "$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId&language=tr-TR",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception("Kategoriye göre film alınamadı: ${response.statusCode}");
    }
  }
}
