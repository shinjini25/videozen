import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videozen/views/screens/comment_screen.dart';
import 'package:flutter_share/flutter_share.dart';
import '../../constants.dart';
import '../../controllers/video_controller.dart';
import '../widgets/circle_animation.dart';
import '../widgets/video_player_card.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({super.key});

  final VideoController videoController = Get.put(VideoController());
  Future<void> shareVideo(String id) async {
    await FlutterShare.share(
      title: 'Explore fun videos at Videozen. Sign up today!',
      text: 'I am inviting you to check out some amazing vidoes on Videozen',
      linkUrl: 'https://flutter.dev/',
    );

    videoController.updateShareCount(id);
  }

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        return PageView.builder(
            itemCount: videoController.videoList.length,
            controller: PageController(initialPage: 0, viewportFraction: 1),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final data = videoController.videoList[index];

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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                                      CommentScreen(
                                                          id: data.id)));
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
                                        onTap: () => shareVideo(data.id),
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
            });
      }),
    );
    // );
  }
}
