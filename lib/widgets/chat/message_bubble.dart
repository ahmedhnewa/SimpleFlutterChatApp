import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.messageDoc, {required Key key}) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>> messageDoc;

  bool get isMe {
    return messageDoc['userUid'] == FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              !isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            Container(
              width: 140,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: !isMe
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // it's not the best soloution
                  // and I don't have cloud functions in my firebase plan
                  // to make this work
                  // but I don't really care since this just a dump app
                  Text(
                    messageDoc['username'] ?? '',
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).textTheme.titleLarge!.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    messageDoc['text'] ?? '',
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).textTheme.titleLarge!.color,
                    ),
                    // onOpen: (link) async {
                    //   final url = Uri.parse(link.url);

                    //   if (await urlLauncher.canLaunchUrl(url)) {
                    //     urlLauncher.launchUrl(url);
                    //   }
                    // },
                  ),
                ],
              ),
            ),
          ],
        ),
        // if (!isMe)
        Positioned(
          top: 0,
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          child: (messageDoc.exists &&
                  messageDoc.data().containsKey('userImageUrl') &&
                  messageDoc.data()['userImageUrl'].toString().isNotEmpty)
              ? CircleAvatar(
                  backgroundImage: NetworkImage(
                    messageDoc['userImageUrl'].toString(),
                  ),
                )
              : const Icon(Icons.person),
        ),
      ],
    );
  }
}
// Card(
//   elevation: 4,
//   child: ListTile(
//     title: Text(message['text']),
//     trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
//   ),
// );