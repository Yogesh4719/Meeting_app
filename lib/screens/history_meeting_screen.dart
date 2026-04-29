import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoom_clone/resources/firestore_methods.dart';

class HistoryMeetingScreen extends StatelessWidget {
  const HistoryMeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirestoreMethods().meetingsHistory,
      builder: (context, snapshot) {
        // ⏳ Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // 🚫 No data
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text("No meetings found"),
          );
        }

        final docs = snapshot.data!.docs;

        // 📭 Empty
        if (docs.isEmpty) {
          return const Center(
            child: Text("No meetings yet"),
          );
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data();

            final meetingName = data['meetingName'] ?? "No Name";
            final createdAt = data['createdAt'];

            return Card(
  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  child: ListTile(
    leading: const Icon(Icons.video_call, color: Colors.blue),
    title: Text(meetingName),
    subtitle: Text(
      createdAt != null
          ? DateFormat.yMMMd().add_jm().format(createdAt.toDate())
          : 'No date',
    ),
  ),
);
          },
        );
      },
    );
  }
}