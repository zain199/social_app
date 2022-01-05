import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_app/layout/cubit/social_home_cubit.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/new_post/cubit/newpost_cubit_states.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/methods.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class NewPostCubit extends Cubit<NewPostCubitStates>
{
  NewPostCubit(): super(NewPostInitState());

  static NewPostCubit get(context)=> BlocProvider.of(context);

  var postText = TextEditingController();

  void checkPost(name,image,context){
    if(filePostImage!=null)
    {
      uploadPostImage(postText.text.trim(), image,name,context);
    }else
      createPost(text: postText.text.trim(), dateTime: DateTime.now().toString(), postUserName: name,postUserImage: image,context: context);
  }

  XFile selectedPostImage;
  File filePostImage;
  String postImage;

  Future<void> pickPostImage() async {

    if(!await Permission.storage.status.isGranted)
    {
      await Permission.storage.request();
    }else
    {
      selectedPostImage =
      await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 30);
      if (selectedPostImage != null) {
        {
          filePostImage = File(selectedPostImage.path);
          emit(NewPostPickPostImageState());
        }
      } else {
        print('something went wrong');
      }
    }

  }

  void cancelPickPostImage(){
    filePostImage = null;
    emit(NewPostCancelPickPostImageState());
  }

  void uploadPostImage(text,postUserImage,postUserName,context) {
    emit(NewPostUploadingPostImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri
        .file(filePostImage.path)
        .pathSegments
        .last}')
        .putFile(filePostImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        postImage = value.toString();
        createPost(text: text, dateTime: DateTime.now().toString(),context: context  ,postUserName:postUserName,postUserImage: postUserImage,);
        emit(NewPostUploadingPostImageSuccessState());
      }).catchError((onError) {
        print('error on add post image ' + onError.toString());
        toastMessage(msg: 'uploading image failed', state: 2);
        emit(NewPostUploadingPostImageErrorState());
      });
    }).catchError((onError) {

      toastMessage(msg: 'uploading image failed', state: 2);
      emit(NewPostUploadingPostImageErrorState());
    });
  }

  PostModel postModel;
  void createPost({
    @required text,
    image,
    @required context,
    @required dateTime,
    @required postUserImage,
    @required postUserName,
  })
  {
    emit(NewPostCreatePostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(dateTime.toString())
        .set(PostModel(postUserImage: postUserImage, postUserName: postUserName,dateTime: dateTime,postImage: postImage??'',text: text,uid: uId).toMap())
        .then((value) {
      postImage=null;
      toastMessage(msg: 'Posted', state: 0);
      SocialHomeCubit.get(context).setBottomNavItemIndex(0);
      postText.text='';
      emit(NewPostCreatePostSuccessState());
      return true;
    }).catchError((onError){
      print(onError.toString());
      emit(NewPostCreatePostErrorState());
      return false;
    });
  }

}