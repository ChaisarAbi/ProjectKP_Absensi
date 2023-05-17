// import 'package:entry_project/screens/login_nim.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../widgets/custom_textfield.dart';


// class NisPasswordSignup extends StatefulWidget {
//   const NisPasswordSignup({Key? key}) : super(key: key);

//   @override
//   _NisPasswordSignupState createState() => _NisPasswordSignupState();
// }

// class _NisPasswordSignupState extends State<NisPasswordSignup> {
//   final TextEditingController nisController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController namaController = TextEditingController();

//   bool _isLoading = false;

//   void signUpUser() async {
//     setState(() {
//       _isLoading = true;
//     });

//     final String nis = nisController.text.trim();
//     final String password = passwordController.text.trim();
//     final String nama = namaController.text.trim();
//     try {
//       await FirebaseFirestore.instance.collection('user').doc(nis).set({
//         'nis': nis,
//         'password': password,
//         'nama': nama,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Sign up successful')),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(error.toString())),
//       );
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: MediaQuery.of(context).size.height * 0.08),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 child: CustomTextField(
//                   controller: nisController,
//                   hintText: 'Masukan NIS',
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 child: CustomTextField(
//                   controller: passwordController,
//                   hintText: 'Masukan password',
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 child: CustomTextField(
//                   controller: namaController,
//                   hintText: 'Masukan nama',
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : signUpUser,
//                 child: _isLoading
//                     ? const CircularProgressIndicator()
//                     : const Text('Sign Up'),
//               ),
//               const SizedBox(height: 16.0),
//               RichText(
//                 text: TextSpan(
//                   text: 'Sudah punya akun ? ',
//                   style: Theme.of(context).textTheme.bodyText2,
//                   children: [
//                     TextSpan(
//                       text: 'Log in',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         decoration: TextDecoration.underline,
//                       ),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const NisPasswordLogin(),
//                             ),
//                           );
//                         },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
