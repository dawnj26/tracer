import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quinto_assignment4/models/user.dart';
import 'package:quinto_assignment4/screens/client_drawer/history_screen.dart';
import 'package:quinto_assignment4/screens/client_drawer/profile_client_screen.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({super.key, required this.user});

  final Client user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String userID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.primaryColor,
              ),
              child: Text(
                'Trace app',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 32.0,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return ClientProfileScreen(
                        user: user,
                      );
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return const ClientHistoryScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: QrImageView(
          data: userID,
          size: 200.0,
        ),
      ),
    );
  }
}
