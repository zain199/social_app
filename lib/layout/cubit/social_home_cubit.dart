
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_home_cubit_states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/login_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/users_chat_screen/users_chat_screen.dart';
import 'package:social_app/modules/home_screen/home_screen.dart';
import 'package:social_app/modules/new_post/new_post.dart';
import 'package:social_app/modules/profile_screen/profile_screen.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/methods.dart';
class SocialHomeCubit extends Cubit<SocialHomeStates> {
  SocialHomeCubit() : super(SocialHomeInitState());

  static SocialHomeCubit get(context) => BlocProvider.of(context);

  static int bottomNavItemIndex = 0;

  void setBottomNavItemIndex(int index) {
      bottomNavItemIndex = index;
      emit(SocialHomeBottomNavIndexState());
  }

  LoginModel model;

  void getUserData() {
    emit(SocialHomeGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      model = LoginModel.fromJson(value.data());
      emit(SocialHomeGetUserSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(SocialHomeGetUserErrorState());
    });
  }

  List screens = [
    HomeScreen(),
    UsersChatScreen(),
    NewPostScreen(),
    ProfileScreen(),
  ];

  TextEditingController commentControler=TextEditingController();
  void sendComment(String text)
  {

    FirebaseFirestore.instance
        .collection('posts')
        .doc(selectedPostId)
        .collection('comments')
        .add(CommentModel(uId,text,DateTime.now().toString()).toJson())
        .whenComplete(() {
      selectedPostId='';
      toastMessage(msg: 'Done', state: 0);
      emit(SocialHomeSendCommentSuccessState());

    }) ;

  }

  List<String>postId=[];
  List<PostModel> posts=[];
  Future<void> getPosts()
  {

    emit(SocialHomeGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .snapshots()
        .listen((event) {

          posts=[];
          postId=[];
          PostModel postModel;
          for(int i = 0 ; i <= event.docs.length-1;i++)
            {

              getUidUserNameAndImage(event.docs.elementAt(event.docs.length-1-i).data()['uid']).then((value) {
                postModel = new PostModel.fromJson(
                    event.docs.elementAt(event.docs.length - 1 - i).data());
                postModel.postUserImage = value.image;
                postModel.postUserName = value.name;
                posts.add(postModel);
                postId.add(event.docs.elementAt(event.docs.length - 1 - i).id);
                if (i == event.docs.length - 1)
              {
                emit(SocialHomeGetPostsSuccessState());
                getComments();
                //getLikes();
              }
              }).catchError((onError){
                print(onError.toString());
              });
            }

    });

  }

  Map<String,int> comments={};
  Future<void> getComments()
  {
    comments={};
    for(int i = 0 ; i < postId.length;++i)
      {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId[i])
            .collection('comments')
            .orderBy('commentTime')
            .get()
            .then((event) {
          comments[postId[i]] = event.docs.length;
          if(i==postId.length-1)
           {
             getLikes();
           }
        });
      }

  }

  String uidUserName;
  String uidUserImage;
  String selectedPostId='';
  Future<LoginModel> getUidUserNameAndImage(String uid)
  {
      LoginModel postUserData;
     return FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((value) {

        postUserData = LoginModel.fromJson(value.data());
        return postUserData;
      }).catchError((onError){
        print(onError.toString());

      });
  }

  void deletePost(index,postid)
  {

    posts.removeAt(index);
    postId.removeAt(index);

    FirebaseFirestore.instance
    .collection('posts')
    .doc(postid)
    .delete().then((value) {
      toastMessage(msg: 'Deleted', state: 0);
    });

  }


  void setDeviceToken(){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('token')
        .doc('token')
        .set({'token':token});
  }

  void like()
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(selectedPostId)
        .collection('likes')
        .doc(uId)
        .set({'uid':uId})
        .whenComplete(() {
          toastMessage(msg: 'Liked', state: 0);
          likes[selectedPostId]=likes[selectedPostId]+1;
          myLikes[selectedPostId]=true;
          emit(SocialHomeLikeSuccessState());
        });
  }

  Map<String,int>likes={};
  Map<String,bool>myLikes={};

  void getLikes()
  {
    likes={};
    myLikes={};
    for(int i = 0 ; i < postId.length;i++)
      {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId[i])
            .collection('likes')
            .get()
            .then((value){
          likes[postId[i]]=value.docs.length;
          myLikes[postId[i]]=false;
          value.docs.forEach((element) {
            if(element.id==uId)
              myLikes[postId[i]]=true;
          });

          if(i==postId.length-1)
            emit(SocialHomeGetLikesSuccessState());
        });

      }

  }

  void unLike()
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(selectedPostId)
        .collection('likes')
        .doc(uId)
        .delete()
        .whenComplete(() {
      toastMessage(msg: 'Unliked', state: 0);
      myLikes[selectedPostId]=false;
      likes[selectedPostId]=likes[selectedPostId]-1;
      emit(SocialHomeUnLikeSuccessState());
    } );
  }

}
