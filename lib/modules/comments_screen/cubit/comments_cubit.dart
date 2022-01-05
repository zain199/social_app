

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/login_model.dart';
import 'package:social_app/modules/comments_screen/cubit/comments_cubit_states.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/methods.dart';

class CommentsCubit extends Cubit<CommentsCubitStates> {
  CommentsCubit() : super(CommentsCubitInitState());

  static CommentsCubit get(context) => BlocProvider.of(context);

  int likes=0;
  List<CommentModel> comments=[];
  TextEditingController commentControler=TextEditingController();
  bool keyboard=false;

  String selectedPostId='';
  void setSelectedPostId(String id)
  {
    selectedPostId = id;
    emit(CommentsCubitGetPostIdSuccessState());
  }

  void setLikes(likes)
  {
    this.likes=likes;
    emit(CommentsCubitSetLikesSuccessState());
  }

  List<String> commentsId=[];
  void getComments()
  {
    commentsId=[];
    FirebaseFirestore.instance
        .collection('posts')
        .doc(selectedPostId)
        .collection('comments')
        .orderBy('commentTime')
        .snapshots()
        .listen((event) {
          comments=[];
          for(int i = 0 ; i < event.docs.length;i++) {
            getUidUserNameAndImage(event.docs[i].data()['uid']).then((value) {
              CommentModel model = new CommentModel.fromJson(event.docs[i].data());
              model.image=value.image;
              model.name=value.name;
              comments.add(model);
              commentsId.add(event.docs[i].id);
              if(i==event.docs.length-1)
                emit(CommentsCubitGetCommentSuccessState());
            }).catchError((onError){
              print(onError.toString());
            });


          }
    });
  }

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
      emit(CommentsCubitSendCommentSuccessState());
    }) ;

  }

  void deleteComment(index)
  {
    if(comments[index].uid==uId)
      {

        FirebaseFirestore.instance
            .collection('posts')
            .doc(selectedPostId)
            .collection('comments')
            .doc(commentsId[index])
            .delete()
            .whenComplete(() { toastMessage(msg: 'Deleted', state: 0);
            emit(CommentsCubitDeleteCommentSuccessState());
            });
      }else
        toastMessage(msg: 'You Can Not Delete This Comment', state: 2);
  }

}