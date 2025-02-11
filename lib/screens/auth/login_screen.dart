import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nh_manajemen_inventory/providers/auth_provider.dart';
import 'package:nh_manajemen_inventory/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController teleponController = TextEditingController();

    void login() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(teleponController.text);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Sukses: ${teleponController.text}"),
            backgroundColor: const Color(0xFF099AA7),
            duration: const Duration(seconds: 3),
          ),
        );

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Login Gagal',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Welcoming Header Text
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Image.asset('assets/images/nhlogo.png'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Manajemen Inventaris',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF099AA7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                // Email TextField
                TextField(
                  controller: teleponController,
                  decoration: InputDecoration(
                    labelText: 'No HP',
                    labelStyle: const TextStyle(color: Colors.grey),
                    floatingLabelStyle:
                        const TextStyle(color: Color(0xFF099AA7)),
                    prefixIcon:
                        const Icon(Icons.phone, color: Color(0xFF099AA7)),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF099AA7)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF099AA7)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly // Allow only digits
                  ],
                ),
                const Row(
                  children: [
                    Text(
                      'Format 62XX...',
                      style: TextStyle(
                          color: Color(0xFF099AA7),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: const Color(0xFF099AA7),
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
