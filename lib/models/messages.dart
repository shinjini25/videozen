import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timeSent;
  final String messageId;

  Messages({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timeSent,
    required this.messageId,
  });

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'timeSent': timeSent,
        'messageId': messageId,
      };

  static Messages fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Messages(
      senderId: snapshot['senderId'],
      receiverId: snapshot['receiverId'],
      text: snapshot['text'],
      timeSent: snapshot['timeSent'].toDate(),
      messageId: snapshot['messageId'],
    );
  }
}
