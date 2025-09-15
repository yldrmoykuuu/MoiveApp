import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Hakkimizda extends StatefulWidget {
  const Hakkimizda({super.key});

  @override
  State<Hakkimizda> createState() => _HakkimizdaState();
}

class _HakkimizdaState extends State<Hakkimizda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hakkımızda")),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            "🎬 MovieApp\n\n"
                "MovieApp, film ve dizi tutkunları için geliştirilmiş bir keşif platformudur. "
                "Amacımız, kullanıcıların en güncel popüler içeriklere kolayca ulaşmasını, "
                "kategorilere göre filtreleme yapabilmesini ve kendi favori listelerini oluşturabilmesini sağlamaktır.\n\n"
                "Uygulama; The Movie Database (TMDB) API'si üzerinden güncel veriler çekerek "
                "sizlere en doğru ve hızlı içerik deneyimi sunar.\n\n"
                "📌 Özellikler:\n"
                "- Popüler ve trend filmler\n"
                "- Türlere göre filtreleme\n"
                "- Favori listesi oluşturma\n\n"
                "👉 Bizimle iletişime geçmek için profil kısmındaki geri bildirim bölümünü kullanabilirsiniz.",
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
      ),
    );
  }
}
