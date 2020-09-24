import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lol_friend_flutter/app/home/models/userProfile.dart';


class SearchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List> getPassedList(uid) async {
    List<String> passedList = [];
    await _firestore.collection('users').doc(uid).collection('passedList')
      .get().then((docs) {
        for (var doc in docs.docs) {
          if (docs.docs != null) {
            passedList.add(doc.id);
          }
        }
      });
  return passedList;
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

   Future<UserProfile> getUserProfile(uid) async {
    final instance = FirebaseFirestore.instance;
    UserProfile userProfile = UserProfile();
    List<String> passedList = await getPassedList(uid);
    List<String> chosenList = await getChosenList(uid);
    UserProfile currentUser = await getUserInterests(uid);
   //QuerySnapshot
    await instance.collection('users').get().then((users){
      for (var user in users.docs) {
         if ((!chosenList.contains(user.id)) &&
             (user.id != uid) &&
             (currentUser.interestedIn == user.get('gender')) &&
             (currentUser.gender == user.get('interestedIn')) &&
             (!passedList.contains(user.id)))
        {
          DateTime age = user.get('age').toDate();
          userProfile.uid = user.id;
          userProfile.name = user.get('name');
          userProfile.photo = user.get('photoUrl');
          userProfile.age =  age;
          userProfile.location = user.get('location');
          userProfile.gender = user.get('gender');
          userProfile.interestedIn = user.get('interestedIn');
          break;
        }
      }
    });
    return userProfile;
  }

    Future<UserProfile> chooseUser(currentUserId, selectedUserId, name, photoUrl) async {
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chosenList')
        .doc(selectedUserId)
        .set({});

    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('selectedList')
        .doc(currentUserId)
        .set({
      'name': name,
      'photoUrl': photoUrl,
    });
    return getUserProfile(currentUserId);
  }

  Future<UserProfile> passUser(currentUserId, selectedUserId) async {
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('passedList')
        .doc(selectedUserId)
        .set({});

    return getUserProfile(currentUserId);
  }
}