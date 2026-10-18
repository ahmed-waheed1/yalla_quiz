import 'package:firebase_auth/firebase_auth.dart';

/// Anonymous Firebase sign-in. Every device gets a stable uid that the RTDB
/// rules use as the player id.
class AuthService {
  AuthService(this._auth);

  final FirebaseAuth _auth;

  String? get uid => _auth.currentUser?.uid;

  /// Returns the current uid, signing in anonymously first if needed.
  Future<String> ensureSignedIn() async {
    final current = _auth.currentUser;
    if (current != null) return current.uid;
    final credential = await _auth.signInAnonymously();
    return credential.user!.uid;
  }
}
