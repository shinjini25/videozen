import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videozen/views/screens/message_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../constants.dart';
import '../../controllers/msg_controller.dart';
import '../../models/chat_contact.dart';

class GoToMsgScreen extends StatefulWidget {
  const GoToMsgScreen({super.key});

  @override
  State<GoToMsgScreen> createState() => _GoToMsgScreenState();
}

class _GoToMsgScreenState extends State<GoToMsgScreen> {
  final MessageController msgController = Get.put(MessageController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Color accentColor = Colors.greenAccent!;
    return SafeArea(
        // child: Text("hey"),
        child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 22.0,
              top: 26,
              bottom: 26,
            ),
            child: InkWell(
              onTap: () => authController.signOut(),
              child: const Text("Conversations",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.greenAccent)),
            ),
          ),
          Expanded(
              child: StreamBuilder<List<ChatContact>>(
                  stream: msgController.getChatContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // return const CircularProgressIndicator();
                      return SpinKitPulse(color: accentColor.withOpacity(0.7));
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var chatContactData = snapshot!.data![index];
                          return SingleChildScrollView(
                            // ignore: avoid_unnecessary_containers
                            child: Container(
                              child: Center(
                                  child: Column(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        print(chatContactData.contactId);
                                        // move to chat screen
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MessageScreen(
                                                        recieverUserId:
                                                            chatContactData
                                                                .contactId,
                                                        name: chatContactData
                                                            .name)));
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3.0),
                                        child: Container(
                                            height: 80,
                                            width: size.width,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Colors.black,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              chatContactData
                                                                  .profilePic),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              top: 15,
                                                              bottom: 15),
                                                      child: Text(
                                                          chatContactData.name,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18)),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  thickness: 2,
                                                ),
                                              ],
                                            )),
                                      )),
                                ],
                              )),
                            ),
                          );
                        });
                  })),
        ],
      ),
    ));
  }
}
