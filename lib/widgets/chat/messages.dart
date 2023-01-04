import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  Messages({super.key});

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error ${snapshot.error.toString()}'),
          );
        }
        if (snapshot.data == null) {
          return const Center(child: Text('Snapshot data null'));
        }
        final docs = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          controller: scrollController,
          itemCount: docs.length,
          itemBuilder: (context, index) => MessageBubble(
            docs[index],
            key: ValueKey(docs[index].id),
          ),
        );
      },
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdDate', descending: true)
          .snapshots(),
    );
  }
}
