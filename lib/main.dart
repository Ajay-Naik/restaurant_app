import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/pages/providers/cart_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restaurant_app/pages/cart/cart_page.dart';
import 'package:restaurant_app/pages/main/home_page.dart';
import 'package:restaurant_app/themes/theme_provider.dart';
import 'pages/login/login_page.dart';
import 'pages/login/signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
  ],
  child: MyApp(),
)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/cart': (context) => const CartPage(),
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
