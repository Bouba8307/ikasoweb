import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikasoweb/models/user_model.dart';

class UserViewModel extends ChangeNotifier {
  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      _users = querySnapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
    } catch (e) {
      _error = "Erreur lors de la récupération des utilisateurs: $e";
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

   Future<List<UserModel>> searchUsers(String query) async {
    if (query.isEmpty) return _users;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('firstName', isGreaterThanOrEqualTo: query)
        .where('firstName', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    return querySnapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
  }

  Future<void> updateUserStatus(String userId, bool isVerified) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'isVerified': isVerified,
      });
      
      int index = _users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        _users[index].isVerified = isVerified;
        notifyListeners();
      }

      sendNotification(userId, isVerified ? "Votre compte a été vérifié!" : "Votre compte a été suspendu.");
    } catch (e) {
      print("Erreur lors de la mise à jour du statut de l'utilisateur: $e");
    }
  }

  void sendNotification(String userId, String message) {
    // Implémentez ici la logique pour envoyer une notification à l'utilisateur
    print("Notification envoyée à l'utilisateur $userId: $message");
  }

  int getTotalUserCount() => _users.length;

  int getClientCount() => _users.where((user) => !user.isHost).length;

  int getHostCount() => _users.where((user) => user.isHost).length;

  double calculateUserGrowth() {
    // Cette méthode nécessite des données historiques pour être précise
    return 5.0; // 5% de croissance
  }

  double calculateClientGrowth() {
    // Cette méthode nécessite des données historiques pour être précise
    return 3.0; // 3% de croissance
  }

  List<String> getHostAvatars() {
    return _users
        .where((user) => user.isHost && user.displayImage != null)
        .map((user) => user.displayImage.toString())
        .take(4)
        .toList();
  }
}
