import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserCredential> signUp(String email, String password) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user;
  }

  getUser(){
  _auth.currentUser;
  }
}
