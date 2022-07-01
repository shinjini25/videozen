import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../models/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  final Rx<List<Video>> _myVideos = Rx<List<Video>>([]);

//getter fun
  List<Video> get videoList => _videoList.value;

  List<Video> get myVideos => _myVideos.value;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
        firestore.collection('videos').snapshots().map((QuerySnapshot query) {
      //map individual stream data for each video
      List<Video> returnedVideos = [];
      for (var element in query.docs) {
        returnedVideos.add(Video.fromSnap(element));
      }
      return returnedVideos;
    }));
  }

  void getMyVideos(String uid) async {
    //profile videos
    _myVideos.bindStream(firestore
        .collection('videos')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot query) {
      //map individual stream data for each video
      List<Video> returnedVideos = [];
      if (query.docs.isNotEmpty) {
        for (var element in query.docs) {
          returnedVideos.add(Video.fromSnap(element));
        }
      }
      //otherwise returns empty list
      return returnedVideos;
    }));
  }

  void likeVideo(String id) async {
    DocumentSnapshot snap = await firestore.collection('videos').doc(id).get();

    //get currentUser id
    String uid = authController.userData!.uid;

    //if current user has already likes the post
    if ((snap.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid])
      });
      //add current user id to likes
    } else {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  void updateShareCount(String id) async {
    DocumentSnapshot snap = await firestore.collection('videos').doc(id).get();
    int shares = (snap.data()! as dynamic)['shareCount'];
    shares = shares++;
    await firestore.collection('videos').doc(id).update({'shareCount': shares});
  }

  // Delete Post
  Future<String> deletePost(String id) async {
    String res = "Some error occurred";
    try {
      await firestore.collection('videos').doc(id).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
