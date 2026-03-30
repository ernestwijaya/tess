import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DogPage(),
    );
  }
}

class DogPage extends StatefulWidget {
  const DogPage({super.key});

  @override
  State<DogPage> createState() => _DogPageState();
}

class _DogPageState extends State<DogPage> {
  String? imageUrl;
  bool loading = false;

  Future<void> getDogImage() async {
    setState(() {
      loading = true;
    });

    final res = await http.get(
      Uri.parse("https://dog.ceo/api/breeds/image/random"),
    );

    final data = jsonDecode(res.body);

    setState(() {
      imageUrl = data["message"];
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDogImage(); // load awal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Dog Finder"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading)
                const CircularProgressIndicator()
              else if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageUrl!,
                    height: 250,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: getDogImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Ambil Foto Baru"),
              )
            ],
          ),
        ),
      ),
    );
  }
}