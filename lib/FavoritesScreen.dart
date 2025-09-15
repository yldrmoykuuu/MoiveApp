import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Lütfen giriş yapın")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorilerim"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .collection("favorites")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Henüz favori eklenmedi"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: Image.network(
                  data['poster'] ?? "",
                  width: 50,
                  errorBuilder: (_, __, ___) => const Icon(Icons.movie),
                ),
                title: Text(data['title'] ?? "Bilinmeyen"),
                subtitle: Text(
                  "IMDb: ${(data['rating'] as num?)?.toStringAsFixed(1) ?? "?"}",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(user.uid)
                        .collection("favorites")
                        .doc(data['title']) // 🔥 doc id = film title
                        .delete();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
