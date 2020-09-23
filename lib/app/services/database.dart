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
  Future<UserProfile> getUserProfile(uid);
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

  Future<List> getChosenList(uid) async {
    List<String> chosenList = [];
    await _firestore.collection('users').doc(uid).collection('chosenList')
      .get().then((docs) {
        for (var doc in docs.docs) {
          if (docs.docs != null) {
            chosenList.add(doc.id);
          }
        }
      });
  return chosenList;
  }

  Future getUserInterests(uid) async {
    UserProfile _currentuserProfile = UserProfile();
    await _firestore.collection('users').doc(uid).get().then((user){ 
      _currentuserProfile.name = user.get('name');
      _currentuserProfile.photo = user.get('photoUrl');
      _currentuserProfile.gender = user.get('gender');
      _currentuserProfile.interestedIn = user.get('interestedIn');
    });
    return _currentuserProfile;
  }

  @override
   Future<UserProfile> getUserProfile(uid) async {
    final instance = FirebaseFirestore.instance;
    UserProfile userProfile = UserProfile();
    List<String> chosenList = await getChosenList(uid);
    UserProfile currentUser = await getUserInterests(uid);
   
    await instance.collection('users').get().then((users){
      for (var user in users.docs) {
       
         if ((!chosenList.contains(user.id)) &&
             (user.id != uid) &&
             (currentUser.interestedIn == user.get('gender')))
        {
          Timestamp age = user.get('age');
          DateTime ageDateTime = age.toDate();
          userProfile.uid = user.id;
          userProfile.name = user.get('name');
          userProfile.photo = user.get('photoUrl');
          userProfile.age =  ageDateTime;
          userProfile.location = user.get('location');
          userProfile.gender = user.get('gender');
          userProfile.interestedIn = user.get('interestedIn');
          break;
        }
      }
    });
    return userProfile;
  }
}
