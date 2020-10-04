import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoon/locator.dart';
import 'package:cocoon/models/nytimes_model.dart';
import 'package:cocoon/models/user.dart';
import 'package:cocoon/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  //final AuthenticationService _authService = locator<AuthenticationService>();

  Future createUser(AppUser user) async {
    try {
      await _usersCollectionReference.doc(user.id).set(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future getUser(String uid) async {
    try {
      DocumentSnapshot user = await _usersCollectionReference.doc(uid).get();
      final userData = user.data();
      return AppUser.fromData(userData);
    } catch (e) {
      return e.message;
    }
  }

  Future createBookmark(Results story) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      //final user = await firebaseAuth.currentUser;
      //await  FirebaseFirestore.instance.collection('stories').doc(story.url).set(story.toJson());
    } catch (e) {
      return e.message;
    }
  }
}
