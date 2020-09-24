import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String job;
  String survey;
  String type;
  String levels;
  int triesNumber;

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.job,
    this.survey,
    this.type,
    this.levels,
    this.triesNumber,
  });

  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
      id: doc['id'] ?? '',
      firstName: doc['firstName'] ?? '',
      lastName: doc['lastName'] ?? '',
      email: doc['email'] ?? '',
      phoneNumber: doc['phoneNumber'] ?? '',
      job: doc['job'] ?? '',
      survey: doc['survey'] ?? '',
      type: doc['Type'] ?? '',
      levels: doc['levels'] ?? '',
      triesNumber: doc['triesNumber'] ?? '',
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      job: json['job'],
      survey: json['survey'],
      type: json['type'],
      levels: json['levels'],
      triesNumber: json['triesNumber'],
    );
  }
}
