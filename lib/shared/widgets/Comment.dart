import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/widgets/CaptionText.dart';
import 'package:social_app/shared/widgets/SubTiltleText.dart';

class Comment extends StatelessWidget {
  String userImage;
  String userName;
  String textComment;
  String commentTime;

  Comment({@required this.userImage,@required  this.userName,@required  this.textComment,@required  this.commentTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage:
              CachedNetworkImageProvider(userImage),
            ),
            SizedBox(
              width: 7.0,
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    SubTitleText(text: userName,),
                    CaptionText(text:textComment),
                  ],
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey[300],
                    border: Border.all(color: defColor)
                ),
                padding: EdgeInsets.only(
                    bottom:  10.0,
                    left: 10.0,
                    right: 10.0
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CaptionText(text:commentTime),
          ],
        ),
      ],
    );
  }
}
