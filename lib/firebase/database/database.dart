import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flat_mate/models/users.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;

class DatabaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  static final userCollection = 'users';
  static final emailCollection = 'user_email';
  final String uid;
  DatabaseService({this.uid});

  Stream<user_email> get currentUserData {
    return _firestore
        .collection(emailCollection)
        .doc(uid)
        .snapshots()
        .map(_userData);
  }

  static Future<String> getImage({username}) async {
    final snapShot = await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(username)
        .get();
    return snapShot.data()['image'];
  }

  static Future<String> getName({username}) async {
    final snapShot = await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(username)
        .get();
    return snapShot.data()['name'];
  }



  static Future<bool> checkUsername({username}) async {
    final snapShot = await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(username)
        .get();
    if (snapShot.exists) {
      return false;
    }
    return true;
  }


  static Future<void> regUser({name, email, username, image, uid}) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('$email/${Path.basename(image.path)}');
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.then((res) {
      res.ref.getDownloadURL();
    }); //  Image Upload code

    await storageReference.getDownloadURL().then((fileURL) async {
      // To fetch the uploaded data's url
      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(username)
          .set({
        'name': name,
        'email': email,
        'username': username,
        'image': fileURL,
      });
      await FirebaseFirestore.instance
          .collection(emailCollection)
          .doc(uid)
          .set({
        'name': name,
        'email': email,
        'username': username,
        'image': fileURL,
      });
      return true;
    });
  }


  user_email _userData(DocumentSnapshot snapshot) {
    if (snapshot.data() != null) {
      return user_email(
        name: snapshot.data()['name'],
        username: snapshot.data()['username'],
        image: snapshot.data()['image'],
        email: snapshot.data()['email'],
      );
    } else {
      return user_email(
        username: null,
        name: null,
        email: null,
        image: null,
      );
    }
  }

  Future<String> addUser(String userName, String email) async {
    String retVal = "error";

    try {
      await _firestore
          .collection('usersData')
          .doc(uid)
          .set({'uid': uid, 'userName': userName, 'email': email});
      retVal = "success";
    } on PlatformException catch (e) {
      retVal = e.message;
    }
    return retVal;
  }

  // Muhammadullah Chat Code Services
  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        // .where('users', arrayContains: itIsMyName)
        .where('usersData', arrayContains: itIsMyName)
        .snapshots();
  }

  // ignore: missing_return
  Future<void> addMessage(String chatRoomId, chatMessageData) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  searchByName(String searchField) async {
    return await FirebaseFirestore.instance
        .collection("user_email")
        .where('username', isEqualTo: searchField)
        .get();
  }

  // ignore: missing_return
  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }
}
