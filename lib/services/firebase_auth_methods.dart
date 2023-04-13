import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entry_project/utils/showOTPDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utils/showSnackBar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);


  //State Persistance
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
  //Firebase.instance.userChanges();
  //Firebase.instance.idTokenChanges();

  //Email Sign Up
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
    required Map<String, String> additionalInfo,
}) async {
    try {
        // membuat user di FirebaseAuth
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // menyimpan data tambahan ke Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set(additionalInfo);
        
        // mengirim email verifikasi
        await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
        showSnackBar(context, e.message!);
    }
}


  //Email Login
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (!_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  //Email Verif
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email Verification has been sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> signInWIthGoogle(BuildContext context) async{
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if(googleAuth?.accessToken != null && googleAuth?.idToken != null){
        // Buat NEw Credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential = await _auth.signInWithCredential(credential);

        //Sign UP
        // if(userCredential.user != null){
        //   if(userCredential.additionalUserInfo!.isNewUser){
        //     //Store Data ke Firestore
        //   }
        // }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  //Phone Number Auth
  Future<void> phoneSignIn(BuildContext context, String phoneNumber) async {
    
    TextEditingController codeController = TextEditingController();
    //WEB but Not Working
    // if(kIsWeb){
    //   ConfirmationResult result = await _auth.signInWithPhoneNumber(phoneNumber);
      
    // } 
    //For Android ^ IOS
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          showSnackBar(context, e.message!);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          //Shows Dialog box
          showOTPDialog(
              codeController: codeController,
              context: context,
              onPressed: () async {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: codeController.text.trim());
                    await _auth.signInWithCredential(credential);
                    Navigator.of(context).pop();
              });
        }),
        codeAutoRetrievalTimeout: (String verificationId) {
          
        })
        ;
  }

  //Anonymous Sign In
  Future<void>signInAnonymously(BuildContext context)async{
    try{
      await _auth.signInAnonymously();
    }on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}
