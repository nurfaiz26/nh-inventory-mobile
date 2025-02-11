import 'package:flutter/material.dart';
import 'package:nh_manajemen_inventory/providers/auth_provider.dart';
import 'package:nh_manajemen_inventory/screens/auth/login_screen.dart';
import 'package:nh_manajemen_inventory/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider()..checkLoginStatus(),
      child: MaterialApp(
        title: 'Manajemen Inventaris',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) {
            final authProvider = Provider.of<AuthProvider>(context);
            final userData = authProvider.userData;
            return userData != null ? const HomeScreen() : const LoginScreen();
          },
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
