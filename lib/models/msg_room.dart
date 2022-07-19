import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String uid;
  List users;

  Room({
    required this.uid,
    required this.users,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'users': users,
      };

  static Room fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Room(
      uid: snapshot['uid'],
      users: snapshot['users'],
    );
  }
}
