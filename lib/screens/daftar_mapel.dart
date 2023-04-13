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
final List<String> _mataPelajaran = [
    'Matematika',
    'Fisika',
    'Kimia',
    'Biologi'
  ];

  final List<String> _siswa = [
    'John',
    'Doe',
    'Jane',
    'Doe',
    'Mark',
    'Johnson',
    'Emily',
    'Smith',
    'Tom',
    'Lee',
    'Sarah',
    'Taylor',
    'David',
    'Brown',
    'Laura',
    'Wilson'
  ];

  List<String> _siswaTerpilih = [];

  Map<String, bool> _siswaHadir = {};

  String? _mataPelajaranTerpilih;
