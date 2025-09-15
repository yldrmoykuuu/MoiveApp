import 'package:flutter/material.dart';

class Yasal extends StatefulWidget {
  const Yasal({super.key});

  @override
  State<Yasal> createState() => _YasalState();
}

class _YasalState extends State<Yasal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yasal ve Politikalar")),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "🔒 Gizlilik Politikası\n",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "Kullanıcılarımızın gizliliği bizim için önemlidir. "
                    "Uygulama içerisinde toplanan bilgiler yalnızca giriş ve kayıt işlemleri için kullanılmakta olup "
                    "üçüncü kişilerle kesinlikle paylaşılmaz.\n",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              Text(
                "📜 Kullanım Şartları\n",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "1️⃣ Uygulama sadece kişisel kullanım içindir.\n"
                    "2️⃣ Kayıt olurken doğru ve güncel bilgiler vermek kullanıcının sorumluluğundadır.\n"
                    "3️⃣ Film ve dizi verileri The Movie Database (TMDB) API’sinden alınmaktadır. "
                    "Uygulama içeriklerin doğruluğundan sorumlu değildir.\n"
                    "4️⃣ Uygulama yalnızca keşif amaçlıdır, film/dizi izleme veya indirme hizmeti sunmaz.\n\n"
                    "Uygulamayı kullanarak bu şartları kabul etmiş sayılırsınız.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
