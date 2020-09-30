
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lol_friend_flutter/app/home/models/userProfile.dart';

class MatchesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMatchedList(uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('matchedList')
        .snapshots();
  }

  Stream<QuerySnapshot> getSelectedList(uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('selectedList')
        .snapshots();
  }

  Future<UserProfile> getUserDetails(uid) async {
    UserProfile _userProfile = UserProfile();

    await _firestore.collection('users').doc(uid).get().then((user) async {
      _userProfile.uid = user.id;
      _userProfile.name = user.get('name');
      _userProfile.photo = user.get('photoUrl');
      _userProfile.age = user.get('age');
      _userProfile.location = user.get('location');
      _userProfile.gender = user.get('gender');
      _userProfile.interestedIn = user.get('interestedIn');
    });

    return _userProfile;
  }

  Future openChat({currentUserId, selectedUserId}) async {
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .set({'timestamp': DateTime.now()});

    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('chats')
        .doc(currentUserId)
        .set({'timestamp': DateTime.now()});

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('matchedList')
        .doc(selectedUserId)
        .delete();

    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('matchedList')
        .doc(currentUserId)
        .delete();
  }

  void deleteUser(currentUserId, selectedUserId) async {
    return await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('selectedList')
        .doc(selectedUserId)
        .delete();
  }

  Future selectUser(currentUserId, selectedUserId, currentUserName,
      currentUserPhotoUrl, selectedUserName, selectedUserPhotoUrl) async {
    deleteUser(currentUserId, selectedUserId);

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('matchedList')
        .doc(selectedUserId)
        .set({
      'name': selectedUserName,
      'photoUrl': selectedUserPhotoUrl,
    });

    return await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('matchedList')
        .doc(currentUserId)
        .set({
      'name': currentUserName,
      'photoUrl': currentUserPhotoUrl,
    });
  }
}
