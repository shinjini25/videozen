import 'package:cloud_firestore/cloud_firestore.dart';

class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  // final DateTime timeSent;
  // final String lastMessage;
  ChatContact({
    required this.name,
    required this.profilePic,
    required this.contactId,
    // required this.timeSent,
    // required this.lastMessage,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'profilePic': profilePic,
        'contactId': contactId,
        // 'timeSent': timeSent.millisecondsSinceEpoch,
        // 'lastMessage': lastMessage,
      };

  static ChatContact fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return ChatContact(
      name: snapshot['name'] ?? '',
      profilePic: snapshot['profilePic'] ?? '',
      contactId: snapshot['contactId'] ?? '',
      // timeSent: DateTime.fromMillisecondsSinceEpoch(snapshot['timeSent']),
      // lastMessage: snapshot['lastMessage'] ?? '',
    );
  }
}
