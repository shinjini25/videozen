// ignore_for_file: prefer_final_fields

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/profile_screen.dart';
import '../../constants.dart';
import '../../controllers/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  // ignore: prefer_final_fields
  late TextEditingController _nameController =
      TextEditingController(text: profileController.user['name']);
  late TextEditingController _emailController =
      TextEditingController(text: profileController.user['email']);
  //current user uid
  final uid = authController.userData.uid;

  bool _isPhotoChanged = false;

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(uid);
  }

  @override
  Widget build(BuildContext context) {
    //onsave function
    void profileOnSave() async {
      await firestore.collection('users').doc(uid).update(
          {'name': _nameController.text, 'email': _emailController.text});

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ProfileScreen(uid: authController.userData.uid)));

      Get.snackbar('Profile Edited!', "Your profile was successfully updated!");
    }

    void changeProfilePhoto() async {
      //storage
      String url =
          await authController.uploadToStorage(authController.editPhoto!);

      //update user collection
      await firestore
          .collection('users')
          .doc(authController.userData.uid)
          .update({'profilePhoto': url});

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EditProfileScreen()));
      Get.snackbar(
          "Photo Changed!", "Your profile picture was successfully updated!");
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
                backgroundColor: Colors.black,
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(uid: authController.userData.uid)));
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: InkWell(
                      //on save function
                      onTap: () {
                        profileOnSave();
                      },
                      child: const Text("Save",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueAccent,
                          )),
                    ),
                  ),
                ],
                title: Text(
                  controller.user['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    //profile pic
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
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),

                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isPhotoChanged != true
                            ? Container(
                                width: 35,
                                height: 35,
                                decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9))),
                                child: InkWell(
                                    onTap: () async {
                                      String res =
                                          await authController.pickEditImg();
                                      if (res == "success") {
                                        setState(() {
                                          _isPhotoChanged = true;
                                        });
                                      }
                                    },
                                    child: const Icon(
                                      Icons.upload,
                                      color: Colors.black,
                                    )))
                            : Container(),
                        const SizedBox(width: 9),
                        (_isPhotoChanged == true)
                            ? InkWell(
                                onTap: () => changeProfilePhoto(),
                                child: const Text("Save New Profile Photo",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    )))
                            : const Text("Update Profile Photo",
                                style: TextStyle(
                                  fontSize: 16,
                                ))
                      ],
                    )),

                    const SizedBox(height: 20),

                    //text fields
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Username',
                              ),
                            ),
                            const SizedBox(height: 20),
                            //email
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                              ),
                            ),
                          ],
                        ))
                  ],
                )),
              ));
        });
  }
}
