import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quinto_assignment4/helpers/firebase_helper.dart';
import 'package:quinto_assignment4/models/user.dart';

class EstablishmentProfileScreen extends StatefulWidget {
  const EstablishmentProfileScreen({super.key, required this.user});

  final BusinessUser user;

  @override
  State<EstablishmentProfileScreen> createState() =>
      _EstablishmentProfileScreenState();
}

class _EstablishmentProfileScreenState
    extends State<EstablishmentProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final addressController = TextEditingController();
  final businessNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    middleNameController.text = widget.user.middleName;
    addressController.text = widget.user.address;
    businessNameController.text = widget.user.businessName;
  }

  void saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final user = BusinessUser(
      firstName: firstNameController.text,
      middleName: middleNameController.text,
      lastName: lastNameController.text,
      email: widget.user.email,
      address: addressController.text,
      businessName: businessNameController.text,
    );

    widget.user.firstName = user.firstName;
    widget.user.middleName = user.middleName;
    widget.user.lastName = user.lastName;
    widget.user.address = user.address;
    widget.user.businessName = user.businessName;

    FireHelper.saveClient(user, context);
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 16.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                gap,
                TextFormField(
                  controller: middleNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Middle name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your middle name';
                    }
                    return null;
                  },
                ),
                gap,
                TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Last name';
                    }
                    return null;
                  },
                ),
                gap,
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Address';
                    }
                    return null;
                  },
                ),
                gap,
                TextFormField(
                  controller: businessNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Business name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your business name';
                    }
                    return null;
                  },
                ),
                gap,
                ElevatedButton(
                  onPressed: saveProfile,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
