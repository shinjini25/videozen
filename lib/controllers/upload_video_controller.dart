//<-- functionality: task of uplaoding the video to Firestore  -->

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:videozen/constants.dart';
import 'package:video_compress/video_compress.dart';
import 'package:videozen/models/video.dart';

class UploadVideoController extends GetxController {
//compress video function
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);

    return compressedVideo!.file;
  }

//upload video to firebase storage function
  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    var compressedVideo = await _compressVideo(videoPath);

    //put the compressed video to Storage and get downloadable url
    UploadTask uploadTask = ref.putFile(compressedVideo);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);

    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // void printShit() async {
  //   String uid = await firebaseAuth.currentUser!.uid;

  //   print("UID ${uid}");

  //   DocumentSnapshot userSnap =
  //       await firestore.collection('users').doc(uid).get();

  //   print("user snap ${userSnap}");

  //   print("username ${(userSnap.data()! as Map<String, dynamic>)['name']}");
  // }

  //upload the video
  Future<String> uploadVideo(
      String songName, String caption, String videoPath) async {
    String res = "Upload was unsuccessful, please try again later";
    try {
      String uid = firebaseAuth.currentUser!.uid;

      print(
          "----------------------------------UID----------------------------------------------- ${uid}");

      DocumentSnapshot userSnap =
          await firestore.collection('users').doc(uid).get();

      print(
          "------------------------------------user snap ----------------------------------------- ${userSnap.data()}");

      //create the unique identifier for the video as video0, video1, video2 etc.
      var totalDocs = await firestore.collection('videos').get();
      int len = totalDocs.docs.length;

      //url that will be stored in firestore
      String videoUrl = await _uploadVideoToStorage("video $len", videoPath);

      print(
          "-----------------------------videoUrl--------------------- ${videoUrl}");

      //thumbnail url stored in firestore
      String thumbnailUrl =
          await _uploadImageToStorage("video $len", videoPath);

      //make a video instance from video model
      Video video = Video(
          username: (userSnap.data() as Map<String, dynamic>)['name'],
          uid: uid,
          id: "video $len",
          likes: [],
          commentCount: 0,
          shareCount: 0,
          // songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          profilePhoto:
              (userSnap.data() as Map<String, dynamic>)['profilePhoto'],
          thumbnail: thumbnailUrl);

      //store video in firestore
      await firestore
          .collection('videos')
          .doc("video $len")
          .set(video.toJson());

      res = "success";

      Get.snackbar("Upload Successful!", "Video was successfully added");
      Get.back();
    } catch (e) {
      print(
          "GOING IN CATCH BLOCK ----------------------------------------------------------------------");
      res = "Unsuccessful";
      print("ERORRRRRRRRRRRRRRRRRRRRRRRR");
      print(e.toString());
      Get.snackbar("Error Uploading Video", e.toString());
    }
    return res;
  }
}
