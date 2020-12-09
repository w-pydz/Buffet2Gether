import 'package:firebase_auth/firebase_auth.dart';
import 'package:buffet2gether_home/services/database.dart';
import 'package:buffet2gether_home/models/profile_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //creat user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

//auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

//sign in with email-password

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      print(email);
      print(password);
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//register
  Future registerWithEmailAndPassword(
      String email,
      String password,
      //String profilePic,
      //String username,
      //String gender,
      //DateTime dateOfBirth
      ) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      //creat a new doc for the user with uid
      await DatabaseService(uid: user.uid).updateUserData(
        ///////////////////default value
          'https://firebasestorage.googleapis.com/v0/b/buffet2gether.appspot.com/o/profile_pictures%2Fdefault.png?alt=media&token=c91f2a65-0928-4eb1-a284-c07c0a8c1517',
          'default', //Username
          'Not Specified', //default gender
          DateTime(1950, 1, 1), //default date of birth
          'Default Bio',
          true,
          true,
          true,
          true,
          true,
          true,
          true,
          false);
      await DatabaseService(uid: user.uid).updateFinish(
          'restaurant ID',
          'name 1',
          'name 2',
          'https://firebasestorage.googleapis.com/v0/b/buffet2gether.appspot.com/o/restaurantAndPromotion_pictures%2Fdefault.jpg?alt=media&token=c2a9c3b4-aef0-4a37-9bc1-a6adf0c407a8',
          'default location',
          'default time',
          0,
          0,
          0,
          DateTime.now(),
          '',
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          'numbertable',
          user.uid);
      await DatabaseService().updateTableData(null, null, user.uid);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

//sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}