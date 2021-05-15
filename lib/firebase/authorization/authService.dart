import 'package:flat_mate/firebase/database/database.dart';
import 'package:flat_mate/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService2 {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser

  Users _userFromFirebase(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  // Listen to the authentication changes

  Stream<Users> get user {
    return _auth
        .authStateChanges()
        //.map((User user) => _userFromFirebase(user));
        .map(_userFromFirebase);
  }

  // sign in with email & Password
  Future<String> signinWithEmail(String email, String password) async {
    String retval = "error";
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      retval = "success";
      // User user = result.user;
      // return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      retval = e.toString();
      // return null;
    }
    return retval;
  }


  Future<int> registerUser({email, name, pass, username, image}) async {
    var _auth = FirebaseAuth.instance;
    try {
      var userNameExists =
          await DatabaseService.checkUsername(username: username);
      if (!userNameExists) {
        return -1;
      }
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);

      var user = result.user;

      await FirebaseAuth.instance.currentUser.updateProfile(
        displayName: '${name}',
        photoURL: '/',
      );

      await DatabaseService.regUser(
          name: name,
          email: email,
          username: username,
          image: image,
          uid: user.uid);
      return 1;
    } catch (e) {
      print(e.code);
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          return -2;
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          return -3;
          break;
        /*
      case 'ERROR_USER_NOT_FOUND':
        authError = 'User Not Found';
        break;
      case 'ERROR_WRONG_PASSWORD':
        authError = 'Wrong Password';
        break;
        */
        case 'ERROR_WEAK_PASSWORD':
          return -4;
          break;
      }
      return 0;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
