// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quinto_assignment4/models/user.dart';
import 'package:quinto_assignment4/screens/establishment_drawer/history_screen.dart';
import 'package:quinto_assignment4/screens/establishment_drawer/profile_screen.dart';

class EstablishmentScreen extends StatelessWidget {
  const EstablishmentScreen({super.key, required this.user});

  final BusinessUser user;

  Future<void> scanQR(BuildContext context) async {
    final qr = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.QR,
    );

    if (qr == '-1') {
      return;
    }

    if (!await validateQR(qr)) {
      QuickAlert.show(
        context: context,
        title: 'Invalid QR',
        text: 'The QR code is not valid',
        type: QuickAlertType.error,
        barrierDismissible: false,
      );

      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    final client = FirebaseFirestore.instance.collection('users/$qr/logs');
    final establishment =
        FirebaseFirestore.instance.collection('users/$currentUser/logs');

    QuickAlert.show(
      context: context,
      title: 'Validating QR',
      text: 'Please wait...',
      type: QuickAlertType.loading,
      barrierDismissible: false,
    );

    // final clientDoc =
    //     await FirebaseFirestore.instance.collection('users').doc(qr).get();
    // final clientData = clientDoc.data()!;

    // final clientName = '${clientData['firstName']} ${clientData['lastName']}';

    try {
      await client.add({
        'establishment': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': DateTime.now().toString(),
      });

      await establishment.add({
        'client': qr,
        'timestamp': DateTime.now().toString(),
      });

      Navigator.pop(context);

      QuickAlert.show(
        context: context,
        title: 'Success',
        text: 'The QR code was successfully validated',
        type: QuickAlertType.success,
        barrierDismissible: false,
      );
    } catch (e) {
      QuickAlert.show(
        context: context,
        title: 'Error',
        text: 'An error occurred while validating the QR code',
        type: QuickAlertType.error,
        barrierDismissible: false,
      );
    }
  }

  Future<bool> validateQR(String qr) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(qr);
    final snapshot = await doc.get();

    return snapshot.exists;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

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
                      return EstablishmentProfileScreen(
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
                      return const EstablishmentHistoryScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        width: screenWidth,
        child: ElevatedButton(
          onPressed: () => scanQR(context),
          child: const Text('Scan QR'),
        ),
      ),
    );
  }
}
