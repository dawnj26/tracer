import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quinto_assignment4/helpers/firebase_helper.dart';
import 'package:quinto_assignment4/models/user.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key, required this.user});

  final Client user;

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final addressController = TextEditingController();
  final dateController = TextEditingController();

  final lastDate = DateTime(9999, 12, 31, 23, 59, 59, 999, 999);
  final firstDate = DateTime(0001);

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    middleNameController.text = widget.user.middleName;
    addressController.text = widget.user.address;
    dateController.text = widget.user.birthdate != null
        ? DateFormat('yyyy-MM-dd').format(widget.user.birthdate!)
        : '';
  }

  Future<void> getDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (date != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(date);
      });
    }
  }

  void saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final user = Client(
      firstName: firstNameController.text,
      middleName: middleNameController.text,
      lastName: lastNameController.text,
      email: widget.user.email,
      address: addressController.text,
      birthdate: dateController.text.isNotEmpty
          ? DateFormat('yyyy-MM-dd').parse(dateController.text)
          : null,
    );

    widget.user.firstName = user.firstName;
    widget.user.middleName = user.middleName;
    widget.user.lastName = user.lastName;
    widget.user.address = user.address;
    widget.user.birthdate = user.birthdate;

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
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Birthdate',
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your birthdate';
                    }
                    return null;
                  },
                  onTap: getDate,
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
