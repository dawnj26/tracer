// ignore_for_file: avoid_classes_with_only_static_members, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quinto_assignment4/models/user.dart';

class FireHelper {
  static const String collectionPath = 'users';
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> registerUser(BuildContext context, Client u) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Registering user...',
    );

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: u.email,
        password: u.password,
      );

      await _firestore
          .collection(collectionPath)
          .doc(userCredential.user!.uid)
          .set({
        'firstName': u.firstName,
        'lastName': u.lastName,
        'role': 'client',
      });

      Navigator.pop(context);

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'User registered',
        onConfirmBtnTap: () {
          Navigator.pop(context);

          context.pop();
        },
        barrierDismissible: false,
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: e.message ?? 'An error occurred',
      );
    }
  }

  static Future<void> registerBusinessUser(
    BuildContext context,
    BusinessUser u,
  ) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Registering user...',
    );
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: u.email,
        password: u.password,
      );
      await _firestore
          .collection(collectionPath)
          .doc(userCredential.user!.uid)
          .set({
        'firstName': u.firstName,
        'lastName': u.lastName,
        'role': 'business',
        'businessName': u.businessName,
      });

      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'User registered',
        onConfirmBtnTap: () {
          Navigator.pop(context);

          context.pop();
        },
        barrierDismissible: false,
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: e.message ?? 'An error occurred',
      );
    }
  }

  static Future<void> signIn(
      BuildContext context, String email, String password) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Signing in...',
    );
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pop(context);

      context.pop();
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: e.message ?? 'An error occurred',
      );
    }
  }
}
