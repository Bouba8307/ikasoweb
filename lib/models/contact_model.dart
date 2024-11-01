import 'package:flutter/material.dart';
import 'package:ikasoweb/models/user_model.dart';

class ContactModel {
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  MemoryImage? displayImage;

  ContactModel({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.displayImage,
  });

  String getFullNameOfUser() {
    return fullName = "${firstName ?? ''} ${lastName ?? ''}".trim();
  }

  UserModel createUserFromContact() {
    return UserModel(
      id: id!,
      firstName: firstName!,
      lastName: lastName!,
      fullName: fullName ?? getFullNameOfUser(),
      displayImage: displayImage,
    );
  }
}
