import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_home_cubit.dart';
import 'package:social_app/models/login_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/comments_screen/commets_screen.dart';
import 'package:social_app/modules/loginscreen/login_screen.dart';
import 'package:social_app/modules/profile_screen/cubit/profile_cubit_states.dart';
import 'package:social_app/shared/widgets/ImageViewer.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/methods.dart';
import 'package:social_app/shared/network/local/Cache_Helper.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ProfileCubit extends Cubit<ProfileCubitStates> {
  ProfileCubit() : super(ProfileInitState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  void logout(context) {
    Cache_Helper.removeData('uid');
    uId = null;
    NavigateToAndKill(context, LoginScreen());
    emit(ProfileLogoutState());
  }


  List<PostModel> posts = [];
  List<String> postId = [];

  void getUserPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .where("uid", isEqualTo: uId)
        .orderBy('dateTime',descending: true)
        .snapshots()
        .listen((event) {
          posts = [];
          postId = [];
          event.docs.forEach((element) {
            posts.add(PostModel.fromJson(element.data()));
            postId.add(element.id);
      });

          emit(ProfileGetUserPostsState());
    });
  }

  void deletePost(index) {
      posts.removeAt(index);
      postId.removeAt(index);
      emit(ProfileDeleteUserPostState());
  }


}
