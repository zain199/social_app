import 'package:flutter/material.dart';
import 'package:social_app/modules/edit_profile_screen/cubit/editprofile_cubit.dart';
import 'package:social_app/modules/edit_profile_screen/cubit/editprofile_cubit_states.dart';
import 'package:social_app/shared/methods.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ProgressedCircleAvatar extends StatelessWidget {

  EditProfileCubit editProfileCubit ;
  EditProfileStates state;
  bool profile;


  ProgressedCircleAvatar(this.editProfileCubit, this.state, this.profile);

  @override
  Widget build(BuildContext context) {
    return profile ? CircleAvatar(
      radius: 20.0,
      backgroundColor: Colors.grey[400],
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          IconButton(
            icon: Icon(IconBroken.Camera),
            color: Colors.black,
            onPressed: () {
              editProfileCubit
                  .pickProfileImage()
                  .then((value) {
                if (editProfileCubit.fileProfileImage != null)
                  editProfileCubit.uploadProfileImage(
                      bio: editProfileCubit.bio.text,
                      name: editProfileCubit.name.text,
                      phone: editProfileCubit.phone.text,
                      context:context,
                  );
              }).catchError((onError) {
                print(
                    'on uploading: ' + onError.toString());
                toastMessage(
                    msg: 'Something Went Wrong', state: 2);
              });
            },
          ),
          if (state is EditProfileUploadingProfileImageState)
            CircularProgressIndicator(),
        ],
      ),
    ):CircleAvatar(
      radius: 20.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          IconButton(
            icon: Icon(IconBroken.Camera),
            color: Colors.black,
            onPressed: () {
              editProfileCubit
                  .pickCoverImage()
                  .then((value) {
                if (editProfileCubit.fileCoverImage != null)
                  editProfileCubit.uploadCoverImage(
                    bio: editProfileCubit.bio.text,
                    name: editProfileCubit.name.text,
                    phone: editProfileCubit.phone.text,
                    context:context,
                  );
              }).catchError((onError) {
                print(
                    'on uploading: ' + onError.toString());
                toastMessage(
                    msg: 'Something Went Wrong', state: 2);
              });
            },
          ),
          if (state is EditProfileUploadingCoverImageState)
            CircularProgressIndicator(),
        ],
      ),
    );
  }
}
