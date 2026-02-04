import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../routes/app_routes.dart';
import '../../../core/services/firebase_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isLoading = false;

  final FirebaseAuthService _authService = FirebaseAuthService();
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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.endsWith('@student.iium.edu.my')) {
      return 'Only IIUM student emails are allowed';
    }
    return null;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      User? user = await _authService.login(email, password);

      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        if (user.emailVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigation()),
          );
        } else {
          _showMessage('Please verify your email first. Check your inbox.');
          await _authService.logout();
        }
      } else {
        _showMessage('Login failed. Check your email and password.');
      }
    }
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      User? user = await _authService.signUp(email, password);

      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        await _authService.sendEmailVerification();
        _showMessage('Verification email sent! Please check your inbox and verify your email.');
        setState(() {
          _isLogin = true;
          _passwordController.clear();
          _confirmPasswordController.clear();
        });
      } else {
        _showMessage('Sign up failed. Email may already be in use.');
      }
    }
  }

  void _handleAction() {
    if (_isLogin) {
      _handleLogin();
    } else {
      _handleSignUp();
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

                // MATRIC FIELD
                TextFormField(
                  controller: _matricController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Matric Number', border: OutlineInputBorder(), prefixIcon: Icon(Icons.badge)),
                  validator: _validateMatric,
                ),
                const SizedBox(height: 15),

                // EMAIL FIELD
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 15),

                // PASS FIELD
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
                    onPressed: _isLoading ? null : _handleAction,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A017)),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(_isLogin ? 'LOGIN' : 'SIGN UP', style: const TextStyle(color: Colors.white)),
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
