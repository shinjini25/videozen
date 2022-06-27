import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../controllers/search_controller.dart';
import 'package:get/get.dart';
import 'package:videozen/views/screens/profile_screen.dart';
import '../../models/user.dart';
import 'home_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    void clearSeachScreen() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
    }

    var height = AppBar().preferredSize.height;
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => clearSeachScreen()),
          leadingWidth: 35,
          backgroundColor: Colors.black,
          title: Container(
            height: height / 1.4,
            // color: Colors.white,
            decoration: BoxDecoration(
              color: Colors.grey[500]?.withOpacity(0.35),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 28, color: Colors.greenAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        filled: false,

                        // hintText: '  Search',
                        // hintStyle: TextStyle(
                        //   fontSize: 15,
                        //   color: Colors.grey,
                        // ),
                      ),
                      onFieldSubmitted: (value) =>
                          searchController.searchUser(value),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: searchController.searchedUsers.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 26),
                child: Center(
                  child: Text(
                    'Search for millions of users on Videozen!',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: searchController.searchedUsers.length,
                itemBuilder: (context, index) {
                  User user = searchController.searchedUsers[index];
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(uid: user.uid),
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          user.profilePhoto,
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}
