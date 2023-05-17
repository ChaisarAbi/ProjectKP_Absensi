
import 'package:entry_project/screens/login.dart';
import 'package:flutter/material.dart';
import 'absensi.dart';
class LandingPage extends StatefulWidget {
  final bool showAttendance;

  const LandingPage({Key? key, this.showAttendance = false}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
          const BiodataPage(), const AbsensiTab(),const InformasiTab()
        ],
      ),
    );
  }
}
