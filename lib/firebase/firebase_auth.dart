import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static Future<UserCredential> singInWithEmail(
      String email, String password) async {
    final user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return user;
  }

  static Future<UserCredential> createUserWithEmail(
      String email, String password) async {
    final user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return user;
  }
}
