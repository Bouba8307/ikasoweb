import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikasoweb/models/app_constants.dart';
import 'package:ikasoweb/models/reservation_model.dart';
import 'package:ikasoweb/models/user_model.dart';
import 'package:get/get.dart';

class ReservationsPage extends StatefulWidget {
  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  List<Reservation> reservations = [];

  @override
  void initState() {
    super.initState();
    loadReservations();
  }

  Future<void> loadReservations() async {
    try {
      final reservationsSnapshot =
          await FirebaseFirestore.instance.collection('reservations').get();

      setState(() {
        reservations = reservationsSnapshot.docs.map((doc) {
          return Reservation.fromMap(
              doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      });
    } catch (e) {
      print('Error fetching reservations: $e');
    }
  }

  Future<UserModel?> getUserDetails(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        return UserModel.fromSnapshot(userDoc);
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
    return null;
  }

  Future<String?> getUserImage(String userId) async {
    try {
      // Récupérer l'URL de l'image de l'utilisateur à partir de Firebase Storage
      String imageUrl = await FirebaseStorage.instance
          .ref('userImages/$userId/$userId.png')
          .getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error fetching user image: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toutes les Réservations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: reservations.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservation = reservations[index];
                  return FutureBuilder<UserModel?>(
                    future: getUserDetails(reservation.userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      final user = snapshot.data;

                      return FutureBuilder<String?>(
                        future: getUserImage(reservation.userId),
                        builder: (context, imageSnapshot) {
                          if (imageSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundImage: imageSnapshot.data != null
                                    ? NetworkImage(imageSnapshot.data!)
                                    : const AssetImage(
                                            'assets/images/default_avatar.png')
                                        as ImageProvider,
                                radius: 30,
                              ),
                              title:
                                  Text(user?.getFullNameOfUser() ?? 'Inconnu'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Numéro: ${user?.phoneNumber ?? 'Non renseigné'}'),
                                  Text('Statut: ${reservation.status}'),
                                  Text(
                                      'Du ${reservation.dateDebut.toLocal().toString().split(' ')[0]} au ${reservation.dateFin.toLocal().toString().split(' ')[0]}'), // Format des dates
                                ],
                              ),
                              trailing: Text('${reservation.prixTotal} FCFA'),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
