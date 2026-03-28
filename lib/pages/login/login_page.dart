import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/components/my_textfield.dart';
import 'package:restaurant_app/components/my_button.dart';
import 'package:restaurant_app/themes/dark_mode.dart';
import 'package:restaurant_app/themes/light_mode.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _hidePassword = true;

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
              text: isLoading ? "Loading..." : "Login",
              onPressed: isLoading
                  ? null
                  : () => signInUser(
                      email: emailController.text,
                      password: passwordController.text,
                    ),
            ),

            const Spacer(),

            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),

                    children: [
                      TextSpan(
                        text: "Register now",
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
      // ),
    );
  }

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      // check if fields are empty
      if (email.isEmpty || password.isEmpty) {
        showError("Please fill all fields");
        return;
      }
      setState(() => isLoading = true);

      //sign in with firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //success
      Navigator.pushReplacementNamed(context, '/home');
      return;
  
    } on FirebaseAuthException catch (e) {
      //handle firebase specific error
      String errorMessage;

      if (e.code == 'user-not-found') {
        errorMessage = "No user found";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email";
      } else {
        errorMessage = e.message ?? "Login failed";
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
