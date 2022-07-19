import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:videozen/constants.dart';
import 'package:videozen/views/screens/auth/login_screen.dart';
import 'package:videozen/views/screens/edit_profile_screen.dart';
import 'package:videozen/views/screens/home_screen.dart';
import 'package:videozen/views/screens/message_screen.dart';
import 'package:videozen/views/screens/play_video.dart';
import '../../controllers/msg_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/video_controller.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());
  final VideoController videoController = Get.put(VideoController());

  final MessageController msgController = Get.put(MessageController());

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.uid);
    videoController.getMyVideos(widget.uid);
  }
  //msg is clicked{
  // msg_controller.updateReceiverUid(widget.uid);
  //}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void onSignout() async {
      authController.signOut();
      print("User signed out!");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
    }

    void onEditProfile() async {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EditProfileScreen()));
    }

    void playVideo(int index) async {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PlayVideoScreen(index: index)));
    }

    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (controller.user.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black12,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () => onSignout(),
                    child: const Icon(Icons.logout_outlined, color: Colors.red),
                  ),
                ),
              ],
              title: Text(
                controller.user['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: controller.user['profilePhoto'],
                                  height: 100,
                                  width: 100,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    controller.user['following'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Following',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.black54,
                                width: 1,
                                height: 15,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    controller.user['followers'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Followers',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.black54,
                                width: 1,
                                height: 15,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    controller.user['likes'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Likes',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.uid ==
                                          authController.userData.uid) {
                                        //edit profile function
                                        onEditProfile();
                                      } else {
                                        controller.followUser();
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: size.width / 3,
                                      height: 34,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: secondaryColor,
                                            width: 2,
                                          )),
                                      child: Text(
                                        widget.uid ==
                                                authController.userData.uid
                                            ? 'Edit Profile'
                                            : controller.user['isFollowing']
                                                ? 'Unfollow'
                                                : 'Follow',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                //msg user btn
                                widget.uid == authController.userData.uid
                                    ? Container()
                                    : Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: secondaryColor,
                                            width: 2,
                                          ),
                                          color: Colors.black12,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 2),
                                          child: InkWell(
                                              onTap: () async {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MessageScreen(
                                                                recieverUserId:
                                                                    widget.uid,
                                                                name: controller
                                                                        .user[
                                                                    'name'])));
                                              },
                                              child: const Icon(Icons.mail)),
                                        ))
                              ]),
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(thickness: 3),
                          controller.user['thumbnails'].length == 0
                              ? Column(children: const [
                                  SizedBox(height: 190),
                                  Text("No videos to show",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                      ))
                                ])
                              :
                              // video list
                              GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      controller.user['thumbnails'].length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 5,
                                  ),
                                  itemBuilder: (context, index) {
                                    String thumbnail =
                                        controller.user['thumbnails'][index];
                                    // String videoUrl =
                                    //     controller.user['videoUrls'][index];
                                    return InkWell(
                                      onTap: () => playVideo(index),
                                      child: CachedNetworkImage(
                                        imageUrl: thumbnail,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
