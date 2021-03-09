import 'package:chatty/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseUser;
import 'package:cloud_firestore/cloud_firestore.dart' as fireStore;

class CloudFireStoreService {
  static sendAMessage(
      {required FirebaseUser.User senderUser,
      required User receiverUser,
      String? message,
      String? receiver,
      String? sender,
      String? senderName,
      int? time,
      String? type,
      Function? function}) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(senderUser.uid)
        .collection(receiverUser.uid!)
        .add(
      {
        'name': senderName,
        'message': message,
        'receiver': receiver,
        'sender': sender,
        'time': time,
        'type': type,
      },
    ).whenComplete(() => function);
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(receiverUser.uid)
        .collection(senderUser.uid)
        .add(
      {
        'message': message,
        'receiver': receiver,
        'sender': sender,
        'time': time,
        'type': type,
      },
    ).whenComplete(() => function);
  }

  static addUser(
      {String? uid,
      String? email,
      String? name,
      String? status,
      int? state,
      String? profilePhoto}) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
      'status': status,
      'state': state,
      'profilePhoto': profilePhoto,
    }).whenComplete(() => print('done'));
  }

  static Future<List<User>> fetchAllUsers(FirebaseUser.User? currentUser) async {
    List<User> users = [];
    QuerySnapshot querySnapshot =
        await fireStore.FirebaseFirestore.instance.collection('users').get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser!.uid) {
        var email = querySnapshot.docs[i].get('email');
        var name = querySnapshot.docs[i].get('name');
        var profilePhoto = querySnapshot.docs[i].get('profilePhoto');
        var uid = querySnapshot.docs[i].get('uid');
        var status = querySnapshot.docs[i].get('status');
        int? state = querySnapshot.docs[i].get('state');
        users.add(User(
            name: name,
            email: email,
            profilePhoto: profilePhoto,
            uid: uid,
            state: state,
            status: status));
      }
    }
    return users;
  }
}
