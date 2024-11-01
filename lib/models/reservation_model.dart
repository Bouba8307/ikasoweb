import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String id;
  final String hebergementId;
  final String hebergementNom;
  final String userId;
  final String proprietaireId;
  final DateTime dateDebut;
  final DateTime dateFin;
  final int nombreJours;
  final double prixTotal;
  final String status;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.hebergementId,
    required this.hebergementNom,
    required this.userId,
    required this.proprietaireId,
    required this.dateDebut,
    required this.dateFin,
    required this.nombreJours,
    required this.prixTotal,
    required this.status,
    required this.createdAt,
  });

  factory Reservation.fromMap(Map<String, dynamic> map, String id) {
    return Reservation(
      id: id,
      hebergementId: map['hebergementId'] ?? '',
      hebergementNom: map['hebergementNom'] ?? '',
      userId: map['userId'] ?? '',
      proprietaireId: map['proprietaireId'] ?? '',
      dateDebut: (map['dateDebut'] as Timestamp).toDate(),
      dateFin: (map['dateFin'] as Timestamp).toDate(),
      nombreJours: map['nombreJours'] ?? 0,
      prixTotal: (map['prixTotal'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
