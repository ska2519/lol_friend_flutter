import 'package:lol_friend_flutter/app/home/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class MessagingRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  String uuid = Uuid().v4();

  MessagingRepository(
      {FirebaseStorage firebaseStorage, FirebaseFirestore firestore})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future sendMessage({Message message}) async {
    StorageUploadTask storageUploadTask;
    DocumentReference messageRef = _firestore.collection('messages').doc();
    CollectionReference senderRef = _firestore
        .collection('users')
        .doc(message.senderId)
        .collection('chats')
        .doc(message.selectedUserId)
        .collection('messages');

    CollectionReference receiverUserRef = _firestore
        .collection('users')
        .doc(message.selectedUserId)
        .collection('chats')
        .doc(message.senderId)
        .collection('messages');

    if (message.photo != null) {
      StorageReference photoRef = _firebaseStorage
          .ref()
          .child('messages')
          .child(messageRef.id)
          .child(uuid);

      storageUploadTask = photoRef.putFile(message.photo);

      await storageUploadTask.onComplete.then((photo) async {
        await photo.ref.getDownloadURL().then((photoUrl) async {
          await messageRef.set({
            'senderName': message.senderName,
            'senderId': message.senderId,
            'text': null,
            'photoUrl': photoUrl,
            'timestamp': DateTime.now(),
          });
        });
      });

      senderRef.doc(messageRef.id).set({'timestamp': DateTime.now()});

      receiverUserRef.doc(messageRef.id).set({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.senderId)
          .collection('chats')
          .doc(message.selectedUserId)
          .update({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.selectedUserId)
          .collection('chats')
          .doc(message.senderId)
          .update({'timestamp': DateTime.now()});
    }
    if (message.text != null) {
      await messageRef.set({
        'senderName': message.senderName,
        'senderId': message.senderId,
        'text': message.text,
        'photoUrl': null,
        'timestamp': DateTime.now(),
      });

      senderRef.doc(messageRef.id).set({'timestamp': DateTime.now()});

      receiverUserRef.doc(messageRef.id).set({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.senderId)
          .collection('chats')
          .doc(message.selectedUserId)
          .update({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.selectedUserId)
          .collection('chats')
          .doc(message.senderId)
          .update({'timestamp': DateTime.now()});
    }
  }

  Stream<QuerySnapshot> getMessages({currentUserId, selectedUserId}) {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<Message> getMessageDetail({messageId}) async {
    Message _message = Message();

    await _firestore
        .collection('messages')
        .doc(messageId)
        .get()
        .then((message) {
      _message.senderId = message.get('senderId');
      _message.senderName = message.get('senderName');
      _message.timestamp = message.get('timestamp');
      _message.text = message.get('text');
      _message.photoUrl = message.get('photoUrl');
    });

    return _message;
  }
}
