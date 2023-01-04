import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage(this.scrollController, {super.key});
  final ScrollController scrollController;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  final firestore = FirebaseFirestore.instance;

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;
    FocusScope.of(context).unfocus();
    final message = _messageController.text;
    _messageController.clear();

    final currentUserDocument = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final username = currentUserDocument.data()?['username'] ?? '';
    final userImageUrl = currentUserDocument.data()?['imageUrl'] ?? '';

    // this is not good, if any user change his username
    // it will stil the old username since I don't have cloud functions
    await firestore.collection('chat').add({
      'text': message,
      'userUid': FirebaseAuth.instance.currentUser!.uid,
      'createdDate': FieldValue.serverTimestamp(),
      'username': username,
      'userImageUrl': userImageUrl
    });
    final scrollController = widget.scrollController;
    // scrollController.jumpTo(scrollController.position.maxScrollExtent);
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextField(
              // onEditingComplete: _sendMessage,
              onSubmitted: (value) => _sendMessage(),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.newline,
              // enableSuggestions: true, already true by default
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Send a message...'),
              controller: _messageController,
              onChanged: (value) => setState(() {}),
            ),
          ),
          IconButton(
            onPressed: _messageController.text.isEmpty ? null : _sendMessage,
            icon: Icon(
              _messageController.text.isEmpty
                  ? Icons.send_outlined
                  : Icons.send_rounded,
            ),
          )
        ],
      ),
    );
  }
}
