import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/admin_model.dart';

class DashboardViewModel extends ChangeNotifier {
  AdminUser? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AdminUser? get user => _user;

  Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = AdminUser(uid: userCredential.user!.uid, email: userCredential.user!.email!);
      notifyListeners();

      // Redirection vers le AdminDashboard après connexion réussie
      Navigator.pushReplacementNamed(context, '/admin_dashboard');
    } catch (e) {
      print("Erreur de connexion: $e");
      // Afficher une alerte ou un message d'erreur
    }
  }

  Future<void> signUp(BuildContext context, String email, String password, String firstName, String lastName, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Mettre à jour le profil de l'utilisateur avec le nom complet
      await userCredential.user?.updateProfile(displayName: '$firstName $lastName');
      _user = AdminUser(uid: userCredential.user!.uid, email: userCredential.user!.email!);
      notifyListeners();

      // Redirection vers le AdminDashboard après inscription réussie
      Navigator.pushReplacementNamed(context, '/admin_dashboard');
    } catch (e) {
      print("Erreur d'inscription: $e");
      // Afficher une alerte ou un message d'erreur
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
    
    // Redirection vers la page de connexion
    Navigator.pushReplacementNamed(context, '/login');
  }
}
