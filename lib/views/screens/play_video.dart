import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:videozen/views/screens/comment_screen.dart';

import '../../constants.dart';
import '../../controllers/video_controller.dart';
import '../widgets/circle_animation.dart';
import '../widgets/video_player_card.dart';

class PlayVideoScreen extends StatelessWidget {
  final int index;
  PlayVideoScreen({super.key, required this.index});

  final VideoController videoController = Get.put(VideoController());

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }

  Future<void> shareVideo() async {
    await FlutterShare.share(
      title: 'Explore fun videos at Videozen. Sign up today!',
      text: 'I am inviting you to check out some amazing vidoes on Videozen',
      linkUrl: 'https://flutter.dev/',
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        final data = videoController.myVideos[index];

        return Stack(
          children: [
            VideoPlayerCard(
              videoUrl: data.videoUrl,
            ),
            Column(
                //sized box
                children: [
                  //sized box,
                  Expanded(
                      child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment:
                            //     MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person),
                                  Text(
                                    " ${data.username}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  //delete options
                                  data.uid == authController.userData.uid
                                      ? Container(
                                          child: Column(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      child: ListView(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 16),
                                                          shrinkWrap: true,
                                                          children: [
                                                            'Delete',
                                                          ]
                                                              .map(
                                                                (e) => InkWell(
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            12,
                                                                        horizontal:
                                                                            16),
                                                                    child:
                                                                        Text(e),
                                                                  ),
                                                                  onTap: () {
                                                                    videoController
                                                                        .deletePost(
                                                                            data.id);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  // // remove the dialog box
                                                                  // Navigator.of(context).pop();
                                                                ),
                                                              )
                                                              .toList()),
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(Icons.more_vert),
                                            )
                                          ],
                                        ))
                                      : Container()
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data.caption,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),

                      //sidebar container

                      Container(
                          width: 75,
                          margin: EdgeInsets.only(top: size.height / 2.5),
                          //user profile stat
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //profile photo
                              buildProfile(data.profilePhoto),
                              //likes
                              Column(children: [
                                InkWell(
                                  onTap: () =>
                                      videoController.likeVideo(data.id),
                                  child: Icon(
                                    Icons.favorite,
                                    size: 30,
                                    color: data.likes.contains(
                                            authController.userData!.uid)
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  data.likes.length.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ]),

                              //comemnts

                              Column(children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CommentScreen(id: data.id)));
                                  },
                                  child: const Icon(
                                    Icons.comment,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  data.commentCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ]),

                              //share counte
                              Column(children: [
                                InkWell(
                                  onTap: () => shareVideo(),
                                  child: const Icon(
                                    Icons.reply,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  data.shareCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ]),

                              CircleAnimation(
                                child: buildMusicAlbum(data.profilePhoto),
                              ),
                            ],
                          )),
                    ],
                  )),
                ]),
          ],
        );

        // );
      }),
    );
    // );
  }
}
