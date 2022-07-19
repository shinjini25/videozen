//<------- functionality: Add video button to select a video. On successful selection of video, user is redirected to confirm screen. -->

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants.dart';
import './confirm_screen.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({super.key});

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);

    //if video is not null, redirect to confirm screen
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

//dialog options
  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.gallery, context),
            child: Row(
              children: const [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.camera, context),
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: Row(
              children: const [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SvgPicture.asset(
          //   'assets/video.svg',
          //   height: 240.0,
          //   width: 270.0,
          // ),
          SizedBox(height: 10),
          // Center(
          InkWell(
            onTap: () => showOptionsDialog(context),
            child: Container(
              width: 190,
              height: 55,
              decoration: BoxDecoration(
                color: secondaryColor,
              ),
              //add video button

              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(Icons.upload, color: Colors.black, size: 30),
                    ),
                    Text(
                      "Add video",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
          ),

          SizedBox(height: 80),
          //box
          Container(
              height: 200,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/video.svg',
                    height: 160.0,
                    width: 270.0,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                      width: 170,
                      child: Text(
                          "Share your favorite videos of fond memories along with a caption with the rest of the world!",
                          style: TextStyle(fontSize: 17)))
                ],
              ))
          // ),
        ],
      ),
    ));
  }
}
