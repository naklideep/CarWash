import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ================= SIGN UP =================
  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    UserCredential userCredential;

    try {
      // 1️⃣ Create auth user
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      // 2️⃣ Save user to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3️⃣ Update profile + send verification
      await user.updateDisplayName(name);
      await user.sendEmailVerification();

    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      // 🔥 ROLLBACK AUTH USER IF ANY STEP FAILS
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }

      print('🔥 SIGNUP ERROR REAL MESSAGE: $e');
      throw Exception(e.toString());
    }
  }

  // ================= LOGIN =================
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  // ================= LOGOUT =================
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ================= USER DATA =================
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (_) {
      return null;
    }
  }

  // ================= RESET PASSWORD =================
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  // ================= ERROR HANDLER =================
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
