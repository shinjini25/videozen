import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videozen/models/message.dart';
import 'package:videozen/models/messages.dart';
import '../models/chat_contact.dart';
import '../models/msg_room.dart';
import '../models/user.dart';
import '../constants.dart';
import 'package:uuid/uuid.dart';

// var userModel = User();
class MessageController {
  final _currentUserUid = authController.userData.uid;

//   List _myRooms = [];
//   List get myRooms => _myRooms;

//   final Rx<List<Message>> _messages = Rx<List<Message>>([]);
//   final Rx<List<Room>> _allRooms = Rx<List<Room>>([]);
//   // final List<String> _myRoomUids = ["abc", "cdb"];

//   List<Message> get messages => _messages.value;
//   List<Room> get allRooms => _allRooms.value;
//   // List<String> get myRooms => _myRoomUids;

// //global variable _receiverUid;
//   late String _receiverUid;
//   String get receiverUid => _receiverUid;

//   updateReciverUid(id) {
//     _receiverUid = id;
//   }

//   final Rx<List<Room>> _userRooms = Rx<List<Room>>([]);

//   List<Room> get userRooms => _userRooms.value;

//   Future<List<Map<String, dynamic>>> setFriends() async {
//     print(_myRooms.length);
//     List<Map<String, dynamic>> _friends = [];
//     for (int i = 0; i < _myRooms.length; i++) {
//       print("inside set friends for loop!");
//       _friends.add(await getFriend(_myRooms[i]));
//     }
//     return _friends;
//   }

//   Future<Map<String, dynamic>> getFriend(String roomId) async {
//     final Rx<Map<String, dynamic>> _friend = Rx<Map<String, dynamic>>({});

//     //get room
//     List roomUsers = [];
//     String friendUid = "";
//     String friendName = "";
//     String friendProfilePhoto = "";
//     var snap = await firestore.collection('rooms').doc(roomId).get();

//     roomUsers = snap.data()!['users'];

//     for (var i = 0; i < roomUsers.length; i++) {
//       if (roomUsers[i] != _currentUserUid) {
//         friendUid = roomUsers[i];
//         print("friend uid ${friendUid}");
//       }
//     }
//     // print("friend's uid -------------- ${friendUid}");
//     DocumentSnapshot userDoc =
//         await firestore.collection('users').doc(friendUid).get();
//     friendName = (userDoc.data() as dynamic)['name'];
//     friendProfilePhoto = (userDoc.data()! as dynamic)['profilePhoto'];

//     _friend.value = {
//       'uid': friendUid,
//       'name': friendName,
//       'profilePhoto': friendProfilePhoto
//     };

//     return _friend.value;
//   }

//   Future<bool> fetchMyRooms() async {
//     List<dynamic> rooms = [];
//     _myRooms.clear();
//     await for (var snapshot in firestore.collection('rooms').snapshots()) {
//       int index = 0;
//       for (var room in snapshot.docs) {
//         if ((room.data()! as dynamic)['users'].contains(_currentUserUid)) {
//           var roomUid = await (room.data()! as dynamic)['uid'];
//           print("--");
//           rooms.add(roomUid);
//           // print("_______________________UID____________${roomUid}");
//         }
//       }
//       for (var i = 0; i < rooms.length; i++) {
//         _myRooms.add(rooms[i]);
//       }
//       // return _myRooms;
//       return false;
//     }
//     return false;
//   }

//   fetchRoomMessages(String roomId) async {
//     _messages.bindStream(
//       firestore
//           .collection('rooms')
//           .doc(roomId)
//           .collection('messages')
//           .orderBy('datePublished', descending: false)
//           .snapshots()
//           .map(
//         (QuerySnapshot query) {
//           List<Message> retValue = [];
//           for (var element in query.docs) {
//             retValue.add(Message.fromSnap(element));
//           }
//           return retValue;
//         },
//       ),
//     );
//   }

//   Future<String> createNewRoom() async {
//     //create new room and return its new uid
//     String roomId = const Uuid().v1();
//     Room newRoom = Room(
//       uid: roomId,
//       users: [_currentUserUid, _receiverUid],
//     );
//     await firestore.collection('rooms').doc(roomId).set(newRoom.toJson());
//     return roomId;
//   }

//   Future<String> roomExists() async {
//     // get all rooms
//     String res = "";
//     await for (var snapshot in firestore.collection('rooms').snapshots()) {
//       for (var room in snapshot.docs) {
//         if ((room.data() as dynamic)['users'].contains(_currentUserUid) &&
//             (room.data() as dynamic)['users'].contains(_receiverUid)) {
//           String id = (room.data() as dynamic)['uid'];
//           return id;
//         } else {
//           return res;
//         }
//       }
//     }
//     return res;
//   }

//   Future<String> getRoom() async {
//     String res = await roomExists();
//     print('get room');
//     if (res == "") {
//       print("no room found, creating a new room!");
//       //create new room and return its new uid
//       String newRoom = await createNewRoom();
//       return newRoom;
//     }
//     return res;
//   }

//   void sendMessage(String message) async {
//     try {
//       var uid = authController.userData.uid;
//       String roomid = await getRoom();

//       print("--------ROOM IDDDDD --- ${roomid}");

//       var allDocs = await firestore
//           .collection('rooms')
//           .doc(roomid)
//           .collection('messages')
//           .get();
//       int len = allDocs.docs.length;

//       Message msg = Message(
//         id: 'msg${len}',
//         sender: uid,
//         text: message,
//         recipient: _receiverUid,
//         datePublished: DateTime.now(),
//       );
//       await firestore
//           .collection('rooms')
//           .doc(roomid)
//           .collection('messages')
//           .add(
//             msg.toJson(),
//           );
//     } catch (e) {
//       Get.snackbar('Failed!', 'Message could not be sent');
//     }
//   }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];

      for (var document in event.docs) {
        var chatContact = ChatContact.fromSnap(document);
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromSnap(userData);

        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePhoto,
            contactId: chatContact.contactId,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Messages>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Messages> messages = [];
      try {
        for (var document in event.docs) {
          print("inside loopp");
          messages.add(Messages.fromSnap(document));
          print("done");
        }
        print("checking msgs");

        // return messages;
      } catch (e) {
        print("ERROR---------");
        print(e.toString());
      }
      return messages;
    });
  }

  void _saveDataToContactsSubcollection(
    UserModel senderUserData,
    UserModel? recieverUserData,
    // String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
// users -> reciever user id => chats -> current user id -> set data
    var recieverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePhoto,
      contactId: senderUserData.uid,
    );
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(firebaseAuth.currentUser!.uid)
        .set(
          recieverChatContact.toJson(),
        );
    // users -> current user id  => chats -> reciever user id -> set data
    var senderChatContact = ChatContact(
      name: recieverUserData!.name,
      profilePic: recieverUserData.profilePhoto,
      contactId: recieverUserData.uid,
    );
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(
          senderChatContact.toJson(),
        );
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String? recieverUserName,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required String senderUsername,
  }) async {
    final message = Messages(
      senderId: firebaseAuth.currentUser!.uid,
      receiverId: recieverUserId,
      text: text,
      timeSent: timeSent,
      messageId: messageId,
    );
    // users -> sender id -> reciever id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toJson(),
        );
    // users -> reciever id  -> sender id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toJson(),
        );
  }

  void sendTextMessage({
    required String text,
    required String receiverUsedId,
    required String senderUserId,
  }) async {
    try {
      var timeSent = DateTime.now();

      UserModel receiverUserData;
      UserModel senderUserData;

      var userDataMap =
          await firestore.collection('users').doc(receiverUsedId).get();
      receiverUserData = UserModel.fromSnap(userDataMap);

      var senderDataMap =
          await firestore.collection('users').doc(senderUserId).get();
      senderUserData = UserModel.fromSnap(senderDataMap);

      var messageId = const Uuid().v1();
      // save contact
      _saveDataToContactsSubcollection(
          senderUserData, receiverUserData, timeSent, receiverUsedId);

      //save msg
      _saveMessageToMessageSubcollection(
          messageId: messageId,
          recieverUserName: receiverUserData.name,
          text: text,
          recieverUserId: receiverUsedId,
          senderUsername: senderUserData.name,
          timeSent: timeSent,
          username: senderUserData.name);
    } catch (e) {
      Get.snackbar('Failed!', '${e.toString()}');
    }
  }
}
