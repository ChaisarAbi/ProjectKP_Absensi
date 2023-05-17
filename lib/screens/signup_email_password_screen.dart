import 'package:entry_project/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../services/firebase_auth_methods.dart';
import '../widgets/custom_textfield.dart';

class EmailPasswordSignup extends StatefulWidget {
  const EmailPasswordSignup({Key? key}) : super(key: key);

  @override
  _EmailPasswordSignupState createState() => _EmailPasswordSignupState();
}


class _EmailPasswordSignupState extends State<EmailPasswordSignup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nisController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _isLoading = false;

  void signUpUser() async {
  setState(() {
    isLoading = true;
  });

  FirebaseAuthMethods(FirebaseAuth.instance).signUpWithEmail(
    context: context,
    email: emailController.text,
    password: passwordController.text,
    additionalInfo: {
      'name': nameController.text,
      'nis': nisController.text,
      'phone': phoneController.text,
    },
  );

  await Future.delayed(const Duration(seconds: 2));

  setState(() {
    isLoading = false;
  });

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const EmailPasswordLogin()),
  );
}

bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Sign Up",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: emailController,
              hintText: 'Enter your email',
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: passwordController,
              hintText: 'Enter your password',
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: nameController,
              hintText: 'Enter your name',
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: nisController,
              hintText: 'Enter your NIS',
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: phoneController,
              hintText: 'Enter your phone number',
            ),
          ),if (isLoading)
          const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _isLoading ? null : signUpUser,
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
                    "Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
          ),
          
          const SizedBox(height: 40),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Already have an account? '),
                TextSpan(
                  text: 'Login',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmailPasswordLogin(),),
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
