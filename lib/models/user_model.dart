import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? email;
  String? bio;
  String? city;
  String? country;
  String? phoneNumber;
  bool isHost;
  bool isCurrentlyHosting;
  bool isVerified;
  MemoryImage? displayImage;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.email,
    this.bio,
    this.city,
    this.country,
    this.phoneNumber,
    this.isHost = false,
    this.isCurrentlyHosting = false,
    this.isVerified = false,
    this.displayImage,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      id: snapshot.id,
      firstName: data['firstName'],
      lastName: data['lastName'],
      fullName: data['fullName'],
      email: data['email'],
      bio: data['bio'],
      city: data['city'],
      country: data['country'],
      phoneNumber: data['phoneNumber'],
      isHost: data['isHost'] ?? false,
      isCurrentlyHosting: data['isCurrentlyHosting'] ?? false,
      isVerified: data['isVerified'] ?? false,
    );
  }

  String getFullNameOfUser() {
    return '$firstName $lastName';
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'email': email,
      'bio': bio,
      'city': city,
      'country': country,
      'phoneNumber': phoneNumber,
      'isHost': isHost,
      'isCurrentlyHosting': isCurrentlyHosting,
      'isVerified': isVerified,
    };
  }
}
