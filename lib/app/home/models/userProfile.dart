import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserProfile extends ChangeNotifier{
  String uid;
  String name;
  String gender;
  String interestedIn;
  String photo;
  Timestamp age;
  GeoPoint location;
  UserProfile({
    this.uid,
    this.name,
    this.gender,
    this.interestedIn,
    this.photo,
    this.age,
    this.location,
  });


  UserProfile copyWith({
    String uid,
    String name,
    String gender,
    String interestedIn,
    String photo,
    Timestamp age,
    GeoPoint location,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      interestedIn: interestedIn ?? this.interestedIn,
      photo: photo ?? this.photo,
      age: age ?? this.age,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'gender': gender,
      'interestedIn': interestedIn,
      'photo': photo,
      'age': age,
      'location': location,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data['name'];
    final String gender = data['gender'];
    final String interestedIn = data['interestedIn'];
    final String photo = data['photoUrl'];
    final Timestamp age = data['age'];
    final GeoPoint location = data['location'];

    if (data == null) return null;

    return UserProfile(
      uid: documentId,
      name: name,
      gender: gender,
      interestedIn: interestedIn,
      photo: photo,
      age: age,
      location: location,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UserProfile(uid: $uid, name: $name, gender: $gender, interestedIn: $interestedIn, photo: $photo, age: $age, location: $location)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is UserProfile &&
      o.uid == uid &&
      o.name == name &&
      o.gender == gender &&
      o.interestedIn == interestedIn &&
      o.photo == photo &&
      o.age == age &&
      o.location == location;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      name.hashCode ^
      gender.hashCode ^
      interestedIn.hashCode ^
      photo.hashCode ^
      age.hashCode ^
      location.hashCode;
  }
}
