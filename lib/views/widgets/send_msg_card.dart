import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants.dart';
import '../../controllers/msg_controller.dart';

class SendMessageCard extends StatelessWidget {
  const SendMessageCard({
    Key? key,
    required TextEditingController messageController,
    required this.msgController,
    required this.receiverUsedId,
  })  : _messageController = messageController,
        super(key: key);

  final TextEditingController _messageController;
  final MessageController msgController;

  final String receiverUsedId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 80,
          width: MediaQuery.of(context).size.width - 50,
          decoration: const BoxDecoration(
              // color: Colors.grey[200],
              ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              maxLength: 50,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              controller: _messageController,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                filled: true,
                // fillColor: Colors.grey[300],
                labelText: "Send a message..",
                labelStyle: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
                enabledBorder: OutlineInputBorder(
                  // borderSide: const BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(45),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(45),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
          ),
        ),
        Container(
          width: 30,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: InkWell(
                onTap: () async {
                  msgController.sendTextMessage(
                      text: _messageController.text,
                      receiverUsedId: receiverUsedId,
                      senderUserId: firebaseAuth.currentUser!.uid);
                  _messageController.clear();
                  print("Msg sent");
                },
                child: Icon(Icons.send, color: Colors.grey)),
          ),
        ),
      ],
    );
  }
}
