import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wally/models/app_user.dart';

abstract class BaseAuth {
  String get userId;
  Future<AppUser> signInWithGoogle();
  Stream<AppUser> get authStateChanges;
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final _auth = FirebaseAuth.instance;

  String _userId;
  String get userId => _userId;

  @override
  Future<AppUser> signInWithGoogle() async {
    final _googleSignIn = GoogleSignIn();
    final _googleSignInAccount = await _googleSignIn.signIn();
    final _googleSignInAuthentication =
        await _googleSignInAccount.authentication;

    final _gc = GoogleAuthProvider.credential(
        accessToken: _googleSignInAuthentication.accessToken,
        idToken: _googleSignInAuthentication.idToken);

    final _authResult = await _auth.signInWithCredential(_gc);
    return _mapUserToAppUser(_authResult.user);
  }

  @override
  Stream<AppUser> get authStateChanges =>
      _auth.authStateChanges().map(_mapUserToAppUser);

  AppUser _mapUserToAppUser(User user) {
    if (user == null) return null;
    _userId = user.uid;
    return AppUser(
      id: user.uid,
      displayName: user.displayName,
      email: user.email,
      lastSignIn: DateTime.now(),
      photoUrl: user.photoURL,
    );
  }

  @override
  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), GoogleSignIn().signOut()]);
  }
}
