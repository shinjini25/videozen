import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  final datePublished;
  String sender;
  String text;
  String recipient;

  Message(
      {required this.id,
      required this.sender,
      required this.text,
      required this.recipient,
      required this.datePublished});

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': sender,
        'text': text,
        'recipient': recipient,
        'datePublished': datePublished,
      };

  static Message fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Message(
      id: snapshot['id'],
      sender: snapshot['sender'],
      text: snapshot['text'],
      recipient: snapshot['recipient'],
      datePublished: snapshot['datePublished'],
    );
  }
}
