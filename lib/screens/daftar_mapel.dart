import 'package:flutter/material.dart';

class DaftarMataPelajaran extends StatelessWidget {
  final List<String> mataPelajaran;

  const DaftarMataPelajaran({super.key, required this.mataPelajaran});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mata Pelajaran'),
      ),
      body: ListView.builder(
        itemCount: mataPelajaran.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(mataPelajaran[index]),
            onTap: () {
              Navigator.pop(context, mataPelajaran[index]);
            },
          );
        },
      ),
    );
  }
}