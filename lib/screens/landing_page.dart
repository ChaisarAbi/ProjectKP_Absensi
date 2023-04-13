import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entry_project/screens/daftar_mapel.dart';
import 'package:entry_project/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _nama = '';
  String _nis = '';
  String _no_telp = '';

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

  Map _siswaHadir = {};

  String? _mataPelajaranTerpilih;
  
  bool _sedangMenyimpanAbsensi = false;

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const EmailPasswordLogin()),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getCurrentUserData();
  }

  Future<void> _simpanAbsensi(BuildContext context) async {
    setState(() {
      _sedangMenyimpanAbsensi = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    final absensiRef = FirebaseFirestore.instance.collection('absensi');
    final docId = '$user.uid-${DateTime.now().millisecondsSinceEpoch}';

    final absensiData = {
      'mata_pelajaran': _mataPelajaranTerpilih,
      'tanggal': DateTime.now(),
      'siswa': _siswaTerpilih,
      'hadir': _siswaHadir,
      'guru': _nama,
    };

    try {
      await absensiRef.doc(docId).set(absensiData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Absensi berhasil disimpan.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _mataPelajaranTerpilih = null;
        _siswaTerpilih = [];
        _siswaHadir = {};
        _sedangMenyimpanAbsensi = false;
      });
    }
  }

  Future<void> _getCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    setState(() {
      _nama = userData.data()!['name'];
      _nis = userData.data()!['nis'];
      _no_telp = userData.data()!['phone'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Biodata'),
            Tab(text: 'Absensi'),
            Tab(text: 'Informasi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Biodata Tab
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Biodata',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    const Text('Nama : ', style: TextStyle(fontSize: 16.0)),
                    Text(_nama,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    const Text('NISN : ', style: TextStyle(fontSize: 16.0)),
                    Text(_nis,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    const Text('Nomor Telepon : ',
                        style: TextStyle(fontSize: 16.0)),
                    Text(_no_telp,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          // Absensi Tab
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DaftarMataPelajaran(
                          mataPelajaran: _mataPelajaran,
                        ),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _mataPelajaranTerpilih = result;
                        _siswaTerpilih = _siswa;
                      });
                    }
                  },
                  child: Text(_mataPelajaranTerpilih ?? 'Pilih Mata Pelajaran'),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Daftar Siswa'),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _siswaTerpilih.length,
                    itemBuilder: (BuildContext context, int index) {
                      final siswa = _siswaTerpilih[index];
                      return ListTile(
                        title: Text(siswa),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check),
                              color: _siswaHadir[siswa] == true
                                  ? Colors.green
                                  : null,
                              onPressed: () {
                                setState(() {
                                  _siswaHadir[siswa] = true;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              color: _siswaHadir[siswa] == false
                                  ? Colors.red
                                  : null,
                              onPressed: () {
                                setState(() {
                                  _siswaHadir[siswa] = false;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.autorenew_rounded),
                              color: _siswaHadir[siswa] != null
                                  ? Colors.blue
                                  : null,
                              onPressed: () {
                                setState(() {
                                  _siswaHadir[siswa] =
                                      null; // set attendance to null for each student
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _sedangMenyimpanAbsensi
                      ? null // disable the button while saving the attendance
                      : () async {
                          await _simpanAbsensi(
                              context); // pass the context as a parameter
                        },
                  child: _sedangMenyimpanAbsensi
                      ? const CircularProgressIndicator()
                      : const Text('Simpan Absen'),
                )
              ],
            ),
          ),

          // Informasi Tab
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Informasi'),
                Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                Text(
                    'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
