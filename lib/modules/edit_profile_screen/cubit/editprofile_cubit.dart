import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_app/layout/cubit/social_home_cubit.dart';
import 'package:social_app/models/login_model.dart';
import 'package:social_app/modules/edit_profile_screen/cubit/editprofile_cubit_states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/methods.dart';


class EditProfileCubit extends Cubit<EditProfileStates>
{

  EditProfileCubit():super(EditProfileInitState());

  static EditProfileCubit get(context)=>BlocProvider.of(context);


  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController bio = TextEditingController();

  XFile selectedCover;
  File fileCoverImage;

  Future<void> pickCoverImage() async {

    selectedCover =
    await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 15);
    if (selectedCover != null) {
      {
        fileCoverImage = File(selectedCover.path);
      }
    } else {
      print('something went wrong');
    }

  }

  String coverImage;

  void uploadCoverImage(
      {@required String name, @required String phone, @required String bio,context}) {
    var cubit = SocialHomeCubit.get(context);
    emit(EditProfileUploadingCoverImageState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(fileCoverImage.path)
        .pathSegments
        .last}')
        .putFile(fileCoverImage)
        .then((value) {
      fileCoverImage = null;
      value.ref.getDownloadURL().then((value) {
        coverImage = value.toString();
        FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .update(LoginModel(
            name,
            phone,
            cubit.model.email,
            cubit.model.uid,
            cubit.model.image,
            coverImage,
            bio,
            cubit.model.isEmailVarified)
            .toMap())
            .then((value) {
          cubit.getUserData();
          emit(EditProfileUpdateUserDataSuccessState());
          toastMessage(msg: 'Image will be here soon', state: 0);
        }).catchError((onError) {
          print('error on add cover image ' + onError.toString());
        });
      }).catchError((onError) {
        print('error on get download url ' + onError.toString());
      });
    }).catchError((onError) {
      print('error on upload image ' + onError.toString());
    });
  }



  XFile selectedProfile;
  File fileProfileImage;

  Future<void> pickProfileImage() async {
    selectedProfile =
    await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 15);
    if (selectedProfile != null) {
      {
        fileProfileImage = File(selectedProfile.path);
      }
    } else {
      print('something went wrong');
    }
  }

  String profileImage;

  void uploadProfileImage(
      {@required String name, @required String phone, @required String bio,context}) {
    var cubit = SocialHomeCubit.get(context);
    emit(EditProfileUploadingProfileImageState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(fileProfileImage.path)
        .pathSegments
        .last}')
        .putFile(fileProfileImage)
        .then((value) {
      fileProfileImage = null;
      value.ref.getDownloadURL().then((value) {
        profileImage = value.toString();
        FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .update(LoginModel(
            name,
            phone,
            cubit.model.email,
            cubit.model.uid,
            profileImage,
            cubit.model.cover,
            bio,
            cubit.model.isEmailVarified)
            .toMap())
            .then((value) {
          cubit.getUserData();
          emit(EditProfileUpdateUserDataSuccessState());
          toastMessage(msg: 'Image will be here soon', state: 0);
        }).catchError((onError) {
          print('error on add profile image ' + onError.toString());
        });
      }).catchError((onError) {
        print('error on get download url ' + onError.toString());
      });
    }).catchError((onError) {
      print('error on get download url ' + onError.toString());
    });
  }

  void updateUserData(
      {@required String name, @required String phone, @required String bio,context}) {
    var cubit = SocialHomeCubit.get(context);
    emit(EditProfileUploadingProfileDataState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(LoginModel(
        name,
        phone,
        cubit.model.email,
        cubit.model.uid,
        cubit.model.image,
        cubit.model.cover,
        bio,
        cubit.model.isEmailVarified)
        .toMap()).then((value) {
      cubit.getUserData();
      emit(EditProfileUpdateUserDataSuccessState());
      toastMessage(msg: 'Updated Successfuly', state: 0);
    }).catchError((onError) {
      toastMessage(msg: 'Updated Unuccessfuly ', state: 2);
      print(onError.toString());
    });
  }

}