import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:repiceapp/Hakkimizda.dart';
import 'package:repiceapp/Login.dart';
import 'package:repiceapp/ProfileEdit.dart';
import 'package:repiceapp/Yardim.dart';
import 'package:repiceapp/Yasal.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  bool isPremium = false; // 🔹 Premium durumu

  @override
  Widget build(BuildContext context) {
    final String displayName = user?.displayName ?? "Kullanıcı";
    final String email = user?.email ?? "E-posta yok";

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // sola hizala
            children: [
              const SizedBox(height: 30),

              // Profil bilgileri
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person, size: 30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        // 🔹 Premium ibaresi
                        if (isPremium)
                          const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Text(
                              "🌟 Premium",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileEdit(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Genel
              sectionTitle("Genel"),

              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.black87),
                title: const Text("Bildirim"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  setState(() {
                    isPremium = true; // 🔹 Premium aktif
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Premium aktif edildi ✅")),
                  );
                },
              ),
              const Divider(indent: 16, endIndent: 16),

              // Daha Fazla
              sectionTitle("Daha Fazla"),

              ListTile(
                leading: const Icon(Icons.article, color: Colors.black87),
                title: const Text("Yasal ve Politikalar"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Yasal()),
                  );
                },
              ),
              const Divider(indent: 16, endIndent: 16),

              ListTile(
                leading: const Icon(Icons.help, color: Colors.black87),
                title: const Text("Yardım & Geri Bildirim"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Yardim()),
                  );
                },
              ),
              const Divider(indent: 16, endIndent: 16),

              ListTile(
                leading: const Icon(Icons.info, color: Colors.black87),
                title: const Text("Hakkımızda"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Hakkimizda()),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Çıkış Yap butonu
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Çıkış yapıldı")),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: const Text(
                    "Çıkış Yap",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
