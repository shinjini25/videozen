
## Flutter app for sharing videos with Firebase Authentication and Real-time chat functionality.

 - **Client:** Flutter, GetX
 - **Architecture:** MVC
  
### Features-
1. User state persistence using GetX state management library.
2. Firebase signup, login (using email and password) using Firebase Authentication
3. Upload videos and watch others' videos.
4. Video compression for fast buffering.
4. Like, comment and share videos from feed.
4. Fully functional Real time chat with any user (using Flutter StreamBuilder).
5. Image file upload (to Firebase Storage) using Image Picker library.
4. Set a profile picture while signing in. 
5. Update Profile functionality with pre-filled values from Firebase.
6. Search user functionality and start a conversation feature
7. All conversations under the tab 'messages' in the bottom navigation bar.

 
### Screenshots
![signup](https://user-images.githubusercontent.com/71487701/175515977-555284fb-e69f-4313-9667-2a18c31893ff.png)  ![login](https://user-images.githubusercontent.com/71487701/175515994-993d2dab-119a-4fcf-acf6-40bb6288be46.png)
![3](https://user-images.githubusercontent.com/71487701/175516066-22736e27-1fd9-4620-ae21-0956e8314511.png)

![chat](https://user-images.githubusercontent.com/71487701/179748950-cf5bd247-72a6-40eb-9565-d8d2e84fef22.png)
![add_video](https://user-images.githubusercontent.com/71487701/179748964-5446ac4d-0e47-4e11-8c5a-1ea09ecc31c3.png)
![profile](https://user-images.githubusercontent.com/71487701/179748967-499b0732-fb47-47e4-9b6d-7f073fa69a45.png)
![upd_prof](https://user-images.githubusercontent.com/71487701/179748969-d157e333-6a4e-4022-aac3-4e779a436ff3.png)
![vid](https://user-images.githubusercontent.com/71487701/179748975-e6c15227-07d1-4d8e-bf0e-517e36c7c780.png)
![search_prof](https://user-images.githubusercontent.com/71487701/179748978-baa7cb8a-f748-47a4-8763-0e231416b2a7.png)
![onvo](https://user-images.githubusercontent.com/71487701/179748982-5b3396b8-4ae3-4c33-ba57-7fbfca39c1a2.png)

https://user-images.githubusercontent.com/71487701/180597443-55af9024-1822-4a33-9a67-b278e6879654.mp4

### Note: 
Image Picker plugin requires additional configurational steps for ioS devices. For more information, refer [here](https://pub.dev/packages/image_picker).

**Versions used in the project-:** 

 - Flutter - ^3.1 
 - get: ^4.6.5 
 - firebase_core: ^1.18.0 
 - firebase_auth: ^3.3.20 
 - firebase_storage: ^10.2.18 
 - cloud_firestore: ^3.1.18
  - image_picker: ^0.8.5+3
  -  video_player: ^2.4.5
  - video_compress: ^3.1.1
  - timeago: ^3.2.2
  - cached_network_image: ^3.2.1
  - flutter_share: ^2.0.0
  - flutter_svg: ^1.1.1+1
  - uuid: ^3.0.6
  - flutter_spinkit: ^5.1.0
