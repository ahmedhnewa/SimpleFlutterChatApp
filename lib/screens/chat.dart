import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = Messages();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
          // DropdownButton(
          //   underline: const SizedBox.shrink(),
          //   icon: Icon(
          //     Icons.more_vert,
          //     color: Theme.of(context).iconTheme.color,
          //   ),
          //   items: [
          //     DropdownMenuItem(
          //       value: 'logout',
          //       child: Row(
          //         children: const [
          //           Icon(Icons.logout),
          //           SizedBox(width: 8),
          //           Text('Logout'),
          //         ],
          //       ),
          //     ),
          //   ],
          //   onChanged: (value) {
          //     switch (value) {
          //       case 'logout':
          //         FirebaseAuth.instance.signOut();
          //         break;
          //     }
          //   },
          // )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: messages,
          ),
          NewMessage(messages.scrollController)
        ],
      ),
    );
  }
}
