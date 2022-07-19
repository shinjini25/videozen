import 'package:flutter/material.dart';
import '../../models/messages.dart';

class MessageCard extends StatelessWidget {
  final bool isMe;
  final String timeSent;

  final Messages data;

  const MessageCard({
    Key? key,
    required this.isMe,
    required this.data,
    required this.timeSent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey[700]!;
    Color accentColor = Colors.greenAccent;
    return Column(
      children: [
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45,
            ),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              // color: isMe ? Colors.grey[700] : Colors.white60,
              color: Colors.black,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.grey[700]
                          : accentColor.withOpacity(0.9),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          5,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          data.text,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text("${timeSent}",
                  style: TextStyle(color: Colors.grey[400], fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
