import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quinto_assignment4/screens/dashboard_screen.dart';

import 'package:quinto_assignment4/screens/home_screen.dart';
import 'package:quinto_assignment4/screens/login_screen.dart';
import 'package:quinto_assignment4/screens/registration/register_client_screen.dart';
import 'package:quinto_assignment4/screens/registration/register_establishment_screen.dart';

var router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData) {
            final String uid = snapshot.data!.uid;

            return Dashboard(userID: uid);
          }
          return const HomeScreen();
        },
      ),
      routes: [
        GoRoute(
          name: 'register',
          path: 'register/:type',
          builder: (context, state) {
            final type = state.pathParameters['type'];
            return type == 'client'
                ? const RegisterClientScreen()
                : const RegisterEstablishmentScreen();
          },
        ),
        GoRoute(
          name: 'login',
          path: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
      ],
    ),
  ],
);
