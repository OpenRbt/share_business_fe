import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  set user(User? newUser) {
    _user = newUser;
    notifyListeners();
  }
  Future<User?> get firstUser => _auth.userChanges().first;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        _user = null;
      } else {
        _user = user;
      }
      notifyListeners();
    });
  }
}