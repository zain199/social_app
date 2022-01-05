import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/login_model.dart';
import 'package:social_app/shared/widgets/ImageViewer.dart';
import 'package:social_app/shared/methods.dart';
import 'package:social_app/shared/styles/colors.dart';

class UserCoverImage extends StatelessWidget {

  LoginModel model;


  UserCoverImage(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          InkWell(
            onTap: (){
              NavigateTo(context, ImageViewer(model.cover.toString()));
            },
            child: Container(
              child: Align(
                alignment: AlignmentDirectional.topCenter,
                child: Container(
                  height: 250.0,
                  width: double.infinity,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(model.cover.toString()),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              height: 500.0,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: (){
                NavigateTo(context, ImageViewer(model.image.toString()));
              },
              child: CircleAvatar(
                backgroundColor: defColor,
                radius: 82,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: CachedNetworkImageProvider(model.image.toString()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
