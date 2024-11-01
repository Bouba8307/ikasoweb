import 'package:cloud_firestore/cloud_firestore.dart';

class Hebergement {
  String id; // Identifiant unique de l'hébergement
  String nom; // Nom de l'hébergement
  String description; // Description de l'hébergement
  String ville; // Ville où se situe l'hébergement
  String prixParJour; // Prix par jour
  String prixParMois; // Prix par mois
  List<String> photos; // Liste des URLs des photos
  bool approuve; // Indique si l'hébergement est approuvé ou non
  String proprietaireId; // ID de l'utilisateur qui a posté l'hébergement
  String? phoneNumber; // Numéro de téléphone de l'utilisateur

  Hebergement({
    required this.id,
    required this.nom,
    required this.description,
    required this.ville,
    required this.prixParJour,
    required this.prixParMois,
    required this.photos,
    required this.proprietaireId,
    this.approuve = false,
    this.phoneNumber,
  });

  // Méthode pour créer un objet Hebergement à partir d'un DocumentSnapshot Firestore
  factory Hebergement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Hebergement(
      id: doc.id,
      nom: data['nom'] ?? '',
      description: data['description'] ?? '',
      ville: data['ville'] ?? '',
      prixParJour: data['prixParJour'].toString(),
      prixParMois: data['prixParMois'].toString(),
      photos: List<String>.from(data['photos'] ?? []),
      approuve: data['approuve'] ?? false,
      proprietaireId: data['proprietaireId'] ?? '', // Extract userId from the document data
    );
  }
}
