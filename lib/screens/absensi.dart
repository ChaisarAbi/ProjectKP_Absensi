import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entry_project/screens/daftar_mapel.dart';
import 'package:entry_project/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BiodataPage extends StatefulWidget {
  const BiodataPage({super.key});

  @override
  State<BiodataPage> createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  String _nama = '';
  String _nis = '';
  String _no_telp = '';

  Future<void> _getCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is null.
      return;
    }
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      _nama = userData.data()!['name'];
      _nis = userData.data()!['nis'];
      _no_telp = userData.data()!['phone'];
    });
  }
  

  @override
  void initState() {
    super.initState();
    _getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const Text('Nomor Telepon : ', style: TextStyle(fontSize: 16.0)),
              Text(_no_telp,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class AbsensiTab extends StatefulWidget {
  const AbsensiTab({Key? key}) : super(key: key);

  @override
  _AbsensiTabState createState() => _AbsensiTabState();
}

class _AbsensiTabState extends State<AbsensiTab> {
  bool _isLoggedIn =
      false; // variable untuk mengecek apakah user sudah login atau belum
  late String _nama;
  String _nis = '';
  String _no_telp = '';

  final List<String> _mataPelajaran = [
    'Matematika',
    'Fisika',
    'Kimia',
    'Biologi'
  ];


  final List<String> _siswa = [
    'Bagas priambodo',
    'Doe',
    'Jane',
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

  Widget _buildLoginButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
          if (result != null) {
            setState(() {
              _isLoggedIn = true;
            });
          }
        },
        child: const Text('Login'),
      ),
    );
  }

  Future<void> _dbSiswa(BuildContext context) async{
    final _siswaDB = FirebaseFirestore.instance.collection('absensi');
  }

  Future<void> _simpanAbsensi(BuildContext context) async {
    setState(() {
      _sedangMenyimpanAbsensi = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    final absensiRef = FirebaseFirestore.instance.collection('absensi');
    final docId = '$user.uid-${DateTime.now().millisecondsSinceEpoch}';

    final hadirTidakHadir = _siswaHadir
        .map((key, value) => MapEntry(key, value ? 'Hadir' : 'Tidak Hadir'));

    final absensiData = {
      'nama_guru': _nama,
      'mata_pelajaran': _mataPelajaranTerpilih,
      'nama_siswa': _siswaTerpilih,
      'hadir': hadirTidakHadir,
      'tanggal': DateTime.now(),
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
    if (user == null) {
      // Handle the case where the user is null.
      return;
    }
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      _nama = userData.data()!['name'];
      _nis = userData.data()!['nis'];
      _no_telp = userData.data()!['phone'];
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn
        ? _buildAbsensiTab() // tampilkan tab absensi jika user sudah login
        : _buildLoginButton(); // tampilkan tombol login jika user belum login
  }

  Widget _buildBiodata() {
    return Container(
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
              const Text('Nomor Telepon : ', style: TextStyle(fontSize: 16.0)),
              Text(_no_telp,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAbsensiTab() {
    return Container(
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
              padding: EdgeInsets.zero,
              itemCount: _siswaTerpilih.length,
              itemBuilder: (BuildContext context, int index) {
                final siswa = _siswaTerpilih[index];
                return Container(
                  decoration: BoxDecoration(
                    color:
                        index % 2 == 0 ? Colors.grey[200] : Colors.transparent,
                  ),
                  child: ListTile(
                    title: Text(siswa),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          color:
                              _siswaHadir[siswa] == true ? Colors.green : null,
                          onPressed: () {
                            setState(() {
                              _siswaHadir[siswa] = true;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          color:
                              _siswaHadir[siswa] == false ? Colors.red : null,
                          onPressed: () {
                            setState(() {
                              _siswaHadir[siswa] = false;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.autorenew_rounded),
                          color:
                              _siswaHadir[siswa] != null ? Colors.blue : null,
                          onPressed: () {
                            setState(() {
                              _siswaHadir[siswa] =
                                  null; // set attendance to null for each student
                            });
                          },
                        ),
                      ],
                    ),
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
                : const Text('Simpan Absensi'),
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        final FirebaseAuth auth = FirebaseAuth.instance;
        final UserCredential userCredential =
            await auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.pop(context, true);
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    }
  }
}

class InformasiTab extends StatefulWidget {
  const InformasiTab({super.key});

  @override
  _InformasiTabState createState() => _InformasiTabState();
}

class _InformasiTabState extends State<InformasiTab> {
  // Deklarasi variabel untuk menyimpan data siswa dari database
  late List<DocumentSnapshot> _siswaList;

  // Method untuk mengambil data siswa dari database dan menyimpannya ke dalam variabel
  Future<void> _getSiswaList() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('absensi').get();
  setState(() {
    _siswaList = snapshot.docs;
  });
}

  // Method untuk menampilkan daftar siswa pada widget ListView.builder
 Widget _buildSiswaList() {
  if (_siswaList == null) {
    return const Center(child: CircularProgressIndicator());
  } else {
    return ListView.builder(
      itemCount: _siswaList.length,
      itemBuilder: (context, index) {
        DocumentSnapshot siswa = _siswaList[index];
        return ListTile(
          title: Text(siswa['nama_siswa']),
        );
      },
    );
  }
}

@override
void initState() {
  super.initState();
  _siswaList = []; // Initialize _siswaList here
  _getSiswaList().then((_) {
    setState(() {}); // Trigger rebuild after data is fetched
  });
}


  @override 
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Informasi'),
          const SizedBox(height: 10.0),
          // Tampilkan daftar siswa pada widget ListView.builder
          Expanded(
              child: _siswaList != null
                  ? _buildSiswaList()
                  : const Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}
