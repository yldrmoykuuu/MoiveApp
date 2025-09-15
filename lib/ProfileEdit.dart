import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Firestore'dan user bilgilerini çek
      final doc = await _firestore.collection("users").doc(user.uid).get();
      final data = doc.data();

      setState(() {
        nameController.text = data?["name"] ?? user.displayName ?? "";
        emailController.text = data?["email"] ?? user.email ?? "";
        phoneController.text = data?["phone"] ?? "";
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Firestore güncelle
        await _firestore.collection("users").doc(user.uid).update({
          "name": nameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
        });

        // Auth profiline de isim yansıt
        await user.updateDisplayName(nameController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bilgiler kaydedildi ✅")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profili Düzenle")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              nameController.text,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              emailController.text,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Ad
            _buildTextField(nameController, "Adınız", Icons.person),
            _buildTextField(emailController, "Mail", Icons.email,
                keyboardType: TextInputType.emailAddress),
            _buildTextField(phoneController, "Telefon Numarası", Icons.phone,
                keyboardType: TextInputType.phone),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveUserData,
              child: const Text("Değişiklikleri Kaydet",
                  style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
