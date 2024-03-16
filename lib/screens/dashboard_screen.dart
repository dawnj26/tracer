import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quinto_assignment4/helpers/firebase_helper.dart';
import 'package:quinto_assignment4/models/user.dart';
import 'package:quinto_assignment4/screens/client_screen.dart';
import 'package:quinto_assignment4/screens/establishment_screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key, required this.userID});

  final String userID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FireHelper.getClient(userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          final String role = snapshot.data!['role'].toString();

          if (role == 'client') {
            final user = Client.fromMap(snapshot.data!);
            return ClientScreen(user: user);
          }
          final user = BusinessUser.fromMap(snapshot.data!);

          return EstablishmentScreen(user: user);
        }
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text('Something went wrong!'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: const Text('Sign out'),
              ),
            ],
          ),
        );
      },
    );
  }
}
