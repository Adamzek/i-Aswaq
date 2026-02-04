import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Get current user
  User? getCurrentUser() {
    return auth.currentUser;
  }

  // Sign up with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Sign up error: $e');
      return null;
    }
  }

  // Login with email and password
  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      User? user = auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      print('Email verification error: $e');
    }
  }

  // Check if email is verified
  bool isEmailVerified() {
    User? user = auth.currentUser;
    if (user != null) {
      return user.emailVerified;
    }
    return false;
  }

  // Logout
  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Reset password error: $e');
    }
  }

  // Update user profile
  Future<void> updateProfile(String displayName) async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
      }
    } catch (e) {
      print('Update profile error: $e');
    }
  }
}
