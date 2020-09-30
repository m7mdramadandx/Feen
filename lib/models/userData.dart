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
      id: doc['id'] != null ? doc['id'] : '',
      firstName: doc['firstName'] != null ? doc['firstName'] : 'first_name',
      lastName: doc['lastName'] != null ? doc['lastName'] : 'last_name',
      email: doc['email'] != null ? doc['email'] : 'email',
      phoneNumber: doc['phoneNumber'] != null ? doc['phoneNumber'] : 'phone',
      job: doc['job'] != null ? doc['job'] : 'job',
      survey: doc['survey'] != null ? doc['survey'] : '0',
      type: doc['Type'] != null ? doc['Type'] : 'type',
      levels: doc['levels'] != null ? doc['levels'] : '1',
      triesNumber: doc['triesNumber'] != null ? doc['triesNumber'] : '0',
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
