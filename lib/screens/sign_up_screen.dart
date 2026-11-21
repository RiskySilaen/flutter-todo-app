import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pertemuan6/screens/sign_in_screen.dart';
import '../providers/auth_notifier.dart';
import '../utils/snack_bar_helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final authNotifier = context.watch<AuthNotifier>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up', // PERBAIKAN: Diubah menjadi Sign Up
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: authNotifier.isloading
                      ? null
                      : () async {
                    final success = await context
                        .read<AuthNotifier>()
                        .signUp( // PERBAIKAN: Memanggil signUp, bukan signIn
                      emailController.text.trim(),
                      passwordController.text,
                    );

                    if (!context.mounted) return;

                    if (!success) {
                      SnackBarHelper.show(
                        context,
                        'Register gagal. Periksa email dan password.',
                      );
                    } else {
                      // Opsional: Langsung kembali ke halaman login jika sukses
                      Navigator.pop(context);
                    }
                  },
                  child: authNotifier.isloading
                      ? const CircularProgressIndicator()
                      : const Text('Register'),
                ),

                TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignInScreen(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Sudah punya akun? Sign In',
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