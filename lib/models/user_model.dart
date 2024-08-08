import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String email;
  String name;
  String bio;
  String photoUrl;
  bool isOnline;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.bio,
    required this.photoUrl,
    required this.isOnline,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      email: doc['email'],
      name: doc['name'],
      bio: doc['bio'],
      photoUrl: doc['photoUrl'],
      isOnline: doc['isOnline'],
    );
  }
}
