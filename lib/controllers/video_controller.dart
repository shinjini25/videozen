import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../models/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

//getter fun
  List<Video> get videoList => _videoList.value;
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
}
