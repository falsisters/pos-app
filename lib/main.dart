import 'package:falsisters_pos_app/core/router/auth_guard.dart';
import 'package:falsisters_pos_app/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: "assets/.env");

  // Initialize any web-specific services here

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cashier App',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Add more theme configurations
      ),
      home: const AuthGuard(
        child: HomeScreen(),
      ),
      // Add error handling
      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
