import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../constants.dart';
import '../../controllers/msg_controller.dart';
import '../../models/messages.dart';
import '../widgets/message_card.dart';
import '../widgets/send_msg_card.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MessageScreen extends StatefulWidget {
  // final List<Message> msgs;
  final String recieverUserId;
  final String name;
  const MessageScreen({
    super.key,
    required this.recieverUserId,
    required this.name,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final MessageController msgController = Get.put(MessageController());
  TextEditingController _messageController = TextEditingController();
  final ScrollController messageController = ScrollController();

  // @override
  // void initState() {
  //   super.initState();
  // }
  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color accentColor = Colors.greenAccent!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(children: [
      //top bar
      Container(
        height: 100,
        width: size.width,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //back arrow
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(widget.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
      //messages
      Expanded(
        child: StreamBuilder<List<Messages>>(
            stream: msgController.getChatStream(widget.recieverUserId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SpinKitPulse(color: accentColor.withOpacity(0.7));
                // return const CircularProgressIndicator();
              }
              SchedulerBinding.instance.addPostFrameCallback((_) {
                messageController
                    .jumpTo(messageController.position.maxScrollExtent);
              });
              return ListView.builder(
                  controller: messageController,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = snapshot.data![index];
                    var timeSent = DateFormat.Hm().format(data.timeSent);

                    bool _isMe = false;

                    if (data.senderId == firebaseAuth.currentUser!.uid) {
                      _isMe = true;
                    }
                    return MessageCard(
                        isMe: _isMe, data: data, timeSent: timeSent);
                  });
            }),
      ),

      //send message
      SendMessageCard(
          msgController: msgController,
          receiverUsedId: widget.recieverUserId,
          messageController: _messageController),
    ]));
  }
}
