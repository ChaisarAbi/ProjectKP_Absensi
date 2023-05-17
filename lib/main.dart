
import 'package:entry_project/screens/landing_page.dart';
import 'package:entry_project/screens/login.dart';
import 'package:entry_project/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signOut();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(),
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<FirebaseAuthMethods>(
//           create: (_)=> FirebaseAuthMethods(FirebaseAuth.instance),
//         ),
//         StreamProvider(
//           create: (context) => context.read<FirebaseAuthMethods>().authState
//         , initialData: null,
//         )
//       ],
//       child: const Scaffold(
//         body: AuthWrapper(),
//       ),
//     );
//   }
// }

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final firebaseUser = context.watch<User?>();

//     if(firebaseUser != null){
//       return LandingPage();
//     }
//     return const EmailPasswordLogin();
//   }
// }

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if(firebaseUser != null){
      return const EmailPasswordLogin();
    }
    return const LandingPage(showAttendance: true);
  }
}

// class LandingPage extends StatefulWidget {
//   final bool showAttendance;

//   const LandingPage({Key? key, this.showAttendance = false}) : super(key: key);

//   @override
//   _LandingPageState createState() => _LandingPageState();
// }

// class _LandingPageState extends State<LandingPage> {
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Entry Project'),
//       ),
//       body: Column(
//         children: [
//           if (widget.showAttendance) ...[
//             // Tampilkan halaman absensi di sini
//           ] else ...[
//             // Tampilkan halaman informasi di sini
//           ],
//         ],
//       ),
//     );
//   }
// }
