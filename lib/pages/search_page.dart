import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      appBar: AppBar(
        title: const Text("Search"),
        backgroundColor: const Color(0xFF212121),
      ),
      body: const Center(
        child: Text(
          "Página Search",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
