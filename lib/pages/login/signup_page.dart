import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/components/my_textfield.dart';
import 'package:restaurant_app/components/my_button.dart';
import 'package:restaurant_app/themes/dark_mode.dart';
import 'package:restaurant_app/themes/light_mode.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _hidePassword = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.lock_open_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),

            const SizedBox(height: 25),

            //message, app slogan
            Text(
              "Food Delivery App",
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            const SizedBox(height: 25),

            //name textfield
            MyTextfield(
              controller: nameController,
              hintText: "Name",
              obscureText: false,
              prefixIcon: Icons.person,
            ),

            const SizedBox(height: 20),

            //email textfield
            MyTextfield(
              controller: emailController,
              hintText: "Email",
              obscureText: false,
              prefixIcon: Icons.email_outlined,
            ),

            const SizedBox(height: 20),

            //password textfield
            MyTextfield(
              controller: passwordController,
              hintText: "Password",
              obscureText: _hidePassword,
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _hidePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade500,
                ),
                onPressed: () {
                  setState(() {
                    _hidePassword = !_hidePassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),

            MyButton(
              text: isLoading ? "Loading..." : "Sign up",
              onPressed: isLoading
                  ? null
                  : () => signUpUser(
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    ),
            ),

            const Spacer(),

            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },

                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),

                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
    // ),
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // check if fields are empty
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        showError("Please fill all fields");
        return;
      }
    setState(() => isLoading = true);

      //sign up with firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({'name': name, 'email': email, 'createdAt': Timestamp.now()});
      } catch (e) {
        // Firestore failed
        debugPrint("Firestore error: $e");
      }

      //success
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      //handle firebase specific error
      String errorMessage;

      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email already in use';
      } else if (e.code == "invalid-email") {
        errorMessage = "Invalid Email";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password is too weak";
      } else {
        errorMessage = e.message ?? "Signup failed";
      }

      showError(errorMessage);

    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(content: Text(message)),
    );
  }
}
