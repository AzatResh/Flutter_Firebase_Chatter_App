import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chatter/model/user.dart';

class AuthRepository{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<UserModel> retrieveCurrentUser(){
    return firebaseAuth.authStateChanges().map((User? user){
      if (user != null) {
        return UserModel(id: user.uid, email: user.email.toString());
      } else {
        return  UserModel(id: "empty", email: '');
      }
    });
  }

  Future<List<UserModel>> retrieveUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await firebaseFirestore.collection("users").get();
    return snapshot.docs
        .map((docSnapshot) => UserModel.fromDoc(docSnapshot))
        .toList();
  }

  Future<UserCredential?> signUp(String email, String password) async {
    try{
      UserCredential userCredential = await FirebaseAuth.instance.
        createUserWithEmailAndPassword(email: email, password: password);
        
      verifyEmail();
      return userCredential;
    }
    on FirebaseAuthException catch(error){
      throw FirebaseAuthException(code: error.code, message: error.message);
    }
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try{
      UserCredential userCredential = await FirebaseAuth.instance.
        signInWithEmailAndPassword(email: email, password: password);
      
      return userCredential;
    }
    on FirebaseAuthException catch(error){
      throw FirebaseAuthException(code: error.code, message: error.message);
    }
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  Future<void> verifyEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      return await user.sendEmailVerification();
    }
  }
}