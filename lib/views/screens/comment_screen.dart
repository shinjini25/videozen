import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controllers/comment_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentScreen extends StatelessWidget {
  final String id;
  const CommentScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _commentController = TextEditingController();
    CommentController commentController = CommentController();

    final size = MediaQuery.of(context).size;
    commentController.updatePostId(id);

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Expanded(child: Obx(() {
                  return ListView.builder(
                      itemCount: commentController.comments.length,
                      itemBuilder: (context, index) {
                        final comment = commentController.comments[index];
                        return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.black,
                              backgroundImage:
                                  NetworkImage(comment.profilePhoto),
                            ),
                            title: Row(
                              children: [
                                Text("${comment.username} ",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w700)),
                                Text(comment.comment,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                    timeago
                                        .format(comment.datePublished.toDate()),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(width: 15),
                                Text("${comment.likes.length} likes",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                            trailing: InkWell(
                              onTap: () =>
                                  commentController.likeComment(comment.id),
                              child: Icon(Icons.favorite,
                                  color: comment.likes
                                          .contains(authController.userData.uid)
                                      ? Colors.red
                                      : Colors.white,
                                  size: 18),
                            ));
                      });
                })),
                const Divider(),

                //comment
                ListTile(
                    title: TextFormField(
                      controller: _commentController,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: "Leave a comment",
                        labelStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w700),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: secondaryColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: secondaryColor)),
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () => commentController
                          .postComment(_commentController.text),
                      child: Text("Comment",
                          style:
                              TextStyle(color: secondaryColor, fontSize: 16)),
                    )),
              ],
            )),
      ),
    );
  }
}
