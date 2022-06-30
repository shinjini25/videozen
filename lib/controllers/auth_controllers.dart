//< -- functions: setting inital screen(_setInitialScreen()), observing auth state changes(onReady()),
//                pick image for uplaod(pickImage()), image storage(uploadToStorage), sign up(registerUser), login(loginUser()) and logout user(signOut()) -->

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart' as modelUser;
import '../constants.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/auth/login_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

//reactive variable --> observable
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;
  late Rx<File?> _pickedEditImg;

  late bool _isPicked = false;

  File? get profilePhoto => _pickedImage.value;

  File? get editPhoto => _pickedEditImg.value;

  bool get photoPicked => _isPicked;

  // set setPhotoToNull(String ab) => _pickedEditImg = null;

  User get userData => _user.value!;

//persist user state
  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

//if user is not logged in, go to Login screen
  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  // void isImgEmpty() {
  //   if (editPhoto == null) {
  //     print("NULL EDIT IMG");
  //   } else {
  //     print("Img picked!");
  //   }
  // }

//utility functions
  Future<String> pickEditImg() async {
    String res = "Unsucssessful!";
    try {
      final pickedEditImg =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedEditImg != null) {
        Get.snackbar('Profile Picture',
            'You have successfully selected your profile picture!');
      } else {
        Get.snackbar('Profile Picture', 'Picked img is empty!');
      }
      //observable
      _pickedEditImg = Rx<File?>(File(pickedEditImg!.path));
      _isPicked = true;
      res = "success";
    } catch (e) {
      // isImgEmpty();
      Get.snackbar('Profile Picture', 'Something went wrong! Try again!');
    }
    return res;
  }

//pick an Img with the help of Image picker lib
  void pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        Get.snackbar('Profile Picture',
            'You have successfully selected your profile picture!');
      }
      //observable
      _pickedImage = Rx<File?>(File(pickedImage!.path));
    } catch (e) {
      Get.snackbar('Profile Picture', 'Something went wrong! Try again!');
    }
  }

  // upload to firebase storage
  Future<String> uploadToStorage(File image) async {
    if (image == null) {
      print("IMAGE SUPPLIED TO STORAGE IS NULL");
    }
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

//<---------------------------------------------------------------------------------------------------------->
  //register user function
  Future<String> registerUser(
      String username, String email, String password, File? image) async {
    String res = "Some error occured";

    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        //create a firebase user
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);

        //get the downlaod url after saving the image in Firebase storage
        String downloadUrl = await uploadToStorage(image);

        //pass the details to the custom user model created
        modelUser.User user = modelUser.User(
            name: username,
            email: email,
            uid: cred.user!.uid,
            profilePhoto: downloadUrl);

        //store the user data acording to the modelUser.User in json (Map<String, dynamic>) format model to firestore
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";

        Get.snackbar(
          'Successful!',
          'Your account has been successfully created',
        );
      }

      //field missing
      else {
        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );
    }
    return res;
  }

  //login user function

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);

        Get.snackbar(
          'Login Successful',
          'You\'ve successfully logged in!',
        );
        // print("USER LOGIN SUCCESSFUL");
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Logging in',
        e.toString(),
      );
    }
  }

  //sign out function

  void signOut() async {
    await firebaseAuth.signOut();
  }
}
