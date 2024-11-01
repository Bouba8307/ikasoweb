import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ikasoweb/models/approbation_model.dart';

class ApprovalViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour obtenir les hébergements avec leurs images, téléphone et userId, uniquement ceux qui ne sont pas encore approuvés
  Stream<List<Hebergement>> getHebergementsStream() {
    return _firestore
        .collection('hebergements')
        .where('approuve', isEqualTo: false) // Ne récupérer que les hébergements non approuvés
        .snapshots()
        .asyncMap((snapshot) async {
      final hebergements = await Future.wait(snapshot.docs.map((doc) async {
        final hebergement = Hebergement.fromFirestore(doc);

        // Récupérer les images de la sous-collection 'images'
        final imagesSnapshot = await doc.reference.collection('images').get();
        final images = imagesSnapshot.docs.map((doc) => doc['url'] as String).toList();
        hebergement.photos = images;

        // Récupérer le numéro de téléphone et le userId de celui qui a posté l'hébergement
        final userDoc = await _firestore.collection('users').doc(hebergement.proprietaireId).get();
        if (userDoc.exists) {
          final userData = userDoc.data();
          hebergement.phoneNumber = userData?['phoneNumber'] ?? 'N/A'; // Assigner le numéro de téléphone
        }

        return hebergement;
      }).toList());

      return hebergements;
    });
  }

  


  // Méthode pour approuver un hébergement et le retirer de l'affichage
  Future<void> approveHebergement(String hebergementId) async {
    await _firestore.collection('hebergements').doc(hebergementId).update({
      'approuve': true,
    });
    notifyListeners(); // Notifie l'interface que les données ont été mises à jour
  }

Future<List<Hebergement>> getHebergements() async {
    try {
      final querySnapshot = await _firestore.collection('hebergements').get();
      return querySnapshot.docs.map((doc) => Hebergement.fromFirestore(doc)).toList();
    } catch (e) {
      print("Erreur lors de la récupération des hébergements: $e");
      return [];
    }
  }


  Future<List<Hebergement>> searchHebergements(String query) async {
    if (query.isEmpty) {
      return await getHebergements(); // Obtenir tous les hébergements
    }

    final querySnapshot = await _firestore
        .collection('hebergements')
        .where('nom', isGreaterThanOrEqualTo: query)
        .where('nom', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    return querySnapshot.docs.map((doc) => Hebergement.fromFirestore(doc)).toList();
  }

  // Méthode pour annuler l'approbation d'un hébergement
  Future<void> cancelHebergement(String hebergementId) async {
    await _firestore.collection('hebergements').doc(hebergementId).update({
      'approuve': false,
    });
    notifyListeners();
  }

  // Méthode pour obtenir le nombre total d'hébergements
  Future<int> getTotalHebergements() async {
    final snapshot = await _firestore.collection('hebergements').get();
    return snapshot.docs.length;
  }

  // Méthode pour obtenir le nombre d'hébergements approuvés
  Future<int> getApprovedHebergementsCount() async {
    final snapshot = await _firestore
        .collection('hebergements')
        .where('approuve', isEqualTo: true)
        .get();
    return snapshot.docs.length;
  }

  // Méthode pour obtenir le nombre d'hébergements non approuvés
  Future<int> getPendingHebergementsCount() async {
    final snapshot = await _firestore
        .collection('hebergements')
        .where('approuve', isEqualTo: false)
        .get();
    return snapshot.docs.length;
  }
}
