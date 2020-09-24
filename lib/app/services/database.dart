import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:lol_friend_flutter/app/home/models/userProfile.dart';

//  Database API Design
//strongly typed data models such as <Job> class
//콜렉션과 문서는 데이터베이스와 관련하여하는 것처럼 엄격한 스키마를 따를 필요가 없습니다.

// TOPTIP! FbStore db와 서비스(repository)를 분리하여 데이터베이스 API는 동일하게 유지
//따라서 해당 데이터베이스를 변경해도 나머지 코드에는 영향을 미치지 않습니다.
abstract class DataBase {
  Future<void> setUserProfile(UserProfile userProfile);
}
//document ID 날짜로 저장
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements DataBase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //profile setup
  @override  
  Future<void> setUserProfile(UserProfile userProfile) async {
    StorageUploadTask storageUploadTask;
    storageUploadTask = FirebaseStorage.instance
        .ref()
        .child('userPhotos')
        .child(userProfile.uid)
        .child(userProfile.uid)
        .putFile(File(userProfile.photo));

    return await storageUploadTask.onComplete.then((ref) async {
      await ref.ref.getDownloadURL().then((url) async {
        await _firestore.collection('users').doc(userProfile.uid).set({
          'uid': userProfile.uid,
          'photoUrl': url,
          'name': userProfile.name,
          "location": userProfile.location,
          'gender': userProfile.gender,
          'interestedIn': userProfile.interestedIn,
          'age': userProfile.age
        });
      });
    });
  }
}
