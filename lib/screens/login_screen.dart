import 'package:flutter/material.dart';
import '../main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;

  final TextEditingController _matricController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _validateMatric(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your matric number';
    final regExp = RegExp(r'^\d{7}$');
    if (!regExp.hasMatch(value)) return 'Matric number must be 7 digits';
    int semesterDigit = int.parse(value[2]);
    if (semesterDigit != 1 && semesterDigit != 2) return 'Invalid semester digit (1 or 2)';
    return null;
  }

  void _handleAction() {
    if (_formKey.currentState!.validate()) {
      if (_isLogin) {
        // Log in flow: Direct access
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      } else {
        // Sign up flow: Force them to login after "signing up"
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created! Please login to continue.')),
        );
        setState(() {
          _isLogin = true;
          _passwordController.clear();
          _confirmPasswordController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // LOGO SECTION
                const SizedBox(height: 20),
                Image.asset(
                  'logo/i-aswaq_logo_bg.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                
                Text(
                  _isLogin ? 'Welcome to i-Aswaq' : 'Join i-Aswaq',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFD4A017)),
                ),
                const SizedBox(height: 30),

                // Matric Field
                TextFormField(
                  controller: _matricController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Matric Number', border: OutlineInputBorder(), prefixIcon: Icon(Icons.badge)),
                  validator: _validateMatric,
                ),
                const SizedBox(height: 15),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
                  validator: (value) => (value == null || !value.contains('@')) ? 'Enter valid email' : null,
                ),
                const SizedBox(height: 15),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)),
                  validator: (value) => (value == null || value.length < 6) ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 15),

                // CONFIRM PASSWORD (ONLY IN SIGN UP)
                if (!_isLogin)
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock_reset)),
                    validator: (value) {
                      if (value != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleAction,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A017)),
                    child: Text(_isLogin ? 'LOGIN' : 'SIGN UP', style: const TextStyle(color: Colors.white)),
                  ),
                ),

                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(_isLogin ? "No account? Create one" : "Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
