import 'package:entry_project/screens/signup_email_password_screen.dart';
import 'package:entry_project/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import 'landing_page.dart';

class EmailPasswordLogin extends StatefulWidget {
  static String routeName = '/login-email-password';
  const EmailPasswordLogin({Key? key}) : super(key: key);
  @override
  _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    await FirebaseAuthMethods(FirebaseAuth.instance).loginWithEmail(
      context: context,
      email: emailController.text,
      password: passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });
    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LandingPage()),
                      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Login",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: emailController,
              hintText: 'Enter your email',
            ),
            // child: CustomTextField(
            //   controller: emailController,
            //   hintText: 'Enter your email',
            // ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: passwordController,
              hintText: 'Enter your password',
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: loginUser,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              textStyle: MaterialStateProperty.all(
                const TextStyle(color: Colors.white),
              ),
              minimumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width / 2.5, 50),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : const Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
          ),
          const SizedBox(height: 40),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Don\'t have an account? '),
                TextSpan(
                  text: 'Sign up',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmailPasswordSignup()),
                      );
                    },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
