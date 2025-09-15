import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Yardim extends StatefulWidget {
  const Yardim({super.key});

  @override
  State<Yardim> createState() => _YardimState();
}

class _YardimState extends State<Yardim> {
  final TextEditingController _mesajController = TextEditingController();

  // Mail göndermek için fonksiyon
  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'yldrmoykuuu@gmail.com', // 📩 kendi mail adresin
      query: 'subject=Geri Bildirim&body=${_mesajController.text}',
    );

    if (!await launchUrl(
      emailUri,
      mode: LaunchMode.externalApplication, // 🔑 Önemli
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mail uygulaması açılamadı")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yardım ve Geri Bildirim")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "❓ Yardım Merkezi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "📌 Uygulamada karşılaştığınız sorunlar için aşağıdaki adımları deneyin:\n\n"
                  "1️⃣ İnternet bağlantınızı kontrol edin.\n"
                  "2️⃣ Uygulamayı yeniden başlatın.\n"
                  "3️⃣ Sorun devam ederse bizimle iletişime geçin.\n",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const Divider(height: 32),

            const Text(
              "💬 Geri Bildirim Gönder",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _mesajController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Mesajınızı buraya yazın...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _sendEmail,
              icon: const Icon(Icons.send),
              label: const Text("Gönder",style: TextStyle(color: Colors.blue),),
            ),
          ],
        ),
      ),
    );
  }
}
