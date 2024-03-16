import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quinto_assignment4/helpers/firebase_helper.dart';

class EstablishmentHistoryScreen extends StatefulWidget {
  const EstablishmentHistoryScreen({super.key});

  @override
  State<EstablishmentHistoryScreen> createState() =>
      _EstablishmentHistoryScreenState();
}

class _EstablishmentHistoryScreenState
    extends State<EstablishmentHistoryScreen> {
  DateTime? filterDate;

  final firstDate = DateTime(0001);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: firstDate,
                lastDate: DateTime.now(),
              );

              if (date != null) {
                setState(() {
                  filterDate = date;
                });
              }
            },
            icon: const Icon(Icons.calendar_month),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                filterDate = null;
              });
            },
            child: const Text('All'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: FireHelper.getEstablishmentLogs(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('No logs found'),
              );
            }

            final logs = snapshot.data!;

            if (filterDate != null) {
              logs.removeWhere((element) {
                final date = DateTime.parse(element['timestamp'].toString());

                return date.day != filterDate!.day ||
                    date.month != filterDate!.month ||
                    date.year != filterDate!.year;
              });
            }

            if (logs.isEmpty) {
              return const Center(
                child: Text('No logs found'),
              );
            }

            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (BuildContext context, int index) {
                final time = DateFormat('h:mm a').format(
                    DateTime.parse(logs[index]['timestamp'].toString()));
                final date = DateFormat('MMMM d, yyyy').format(
                    DateTime.parse(logs[index]['timestamp'].toString()));

                return Card(
                  child: ListTile(
                    title: Text(logs[index]['client'].toString()),
                    subtitle: Text('$date @ $time'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
