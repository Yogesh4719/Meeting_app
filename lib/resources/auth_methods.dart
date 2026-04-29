import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zoom_clone/utils/utils.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // auth state changes
  Stream<User?> get authChanges => _auth.authStateChanges();

  // safe current user
  User? get user => _auth.currentUser;

  // Google Sign In
  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser =
          await googleSignIn.signIn();

      // user cancelled login
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        // if new user, store in firestore
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          await _firestore.collection('users').doc(user.uid).set({
            'username': user.displayName ?? "No Name",
            'uid': user.uid,
            'profilePhoto': user.photoURL ?? "",
          });
        }

        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? "Firebase error");
      res = false;
    } catch (e) {
      showSnackBar(context, e.toString());
      res = false;
    }

    return res;
  }

  // Sign out from both Firebase + Google
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}