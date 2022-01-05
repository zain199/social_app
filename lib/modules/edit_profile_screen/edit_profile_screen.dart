import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_home_cubit.dart';
import 'package:social_app/layout/cubit/social_home_cubit_states.dart';
import 'package:social_app/modules/edit_profile_screen/cubit/editprofile_cubit.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/widgets/DefualtTextFormField.dart';
import 'package:social_app/shared/methods.dart';
import 'package:social_app/shared/widgets/ProgressedCircleAvatar.dart';
import '../../shared/widgets/ImageViewer.dart';
import 'cubit/editprofile_cubit_states.dart';

class EditProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialHomeCubit, SocialHomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = SocialHomeCubit.get(context).model;
        return BlocProvider(
          create: (context) =>  EditProfileCubit(),
          child: BlocConsumer<EditProfileCubit,EditProfileStates>(
            listener: (context, state) {
            },
            builder: (context, state) {
              var editProfileCubit = EditProfileCubit.get(context);
              editProfileCubit.name.text = model.name;
              editProfileCubit.phone.text = model.phone;
              editProfileCubit.bio.text = model.bio;
              return  Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      icon: Icon(IconBroken.Arrow___Left_2),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  title: Text('Edit Profile'),
                  titleSpacing: 5.0,
                  actions: [
                    TextButton(
                        onPressed: () {
                          editProfileCubit.updateUserData(
                              name: editProfileCubit.name.text, phone: editProfileCubit.phone.text, bio: editProfileCubit.bio.text,context: context);
                        },
                        child: Text('UPDATE'))
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                      children: [
                        if (state is EditProfileUploadingProfileDataState)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LinearProgressIndicator(),
                          ),
                        Container(
                          height: 310,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Align(
                                alignment: AlignmentDirectional.topCenter,
                                child: Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        NavigateTo(context, ImageViewer(model.cover.toString()));
                                      },
                                      child: Container(
                                        height: 250.0,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(model.cover.toString()),
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    ),

                                    ProgressedCircleAvatar(editProfileCubit,state,false),
                                  ],
                                ),
                              ),
                              Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      NavigateTo(context, ImageViewer(model.image.toString()));
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: defColor,
                                      radius: 82,
                                      child: CircleAvatar(
                                        radius: 80,
                                        backgroundImage:
                                        CachedNetworkImageProvider(model.image.toString()),
                                      ),
                                    ),
                                  ),
                                  ProgressedCircleAvatar(editProfileCubit,state,true),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              DefaultTextFormField(
                                type: TextInputType.name,
                                controller: editProfileCubit.name,
                                validate: (String value) {
                                  if (value.isEmpty) return 'Name must noy be empty';
                                },
                                prefixicon: Icon(IconBroken.User),
                                hint: 'Name',
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              DefaultTextFormField(
                                type: TextInputType.phone,
                                controller: editProfileCubit.phone,
                                validate: (String value) {
                                  if (value.isEmpty) return 'phone must noy be empty';
                                },
                                prefixicon: Icon(IconBroken.Call),
                                hint: 'Phone',
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              DefaultTextFormField(
                                type: TextInputType.text,
                                controller: editProfileCubit.bio,
                                validate: (String value) {
                                  if (value.isEmpty) return 'bio must noy be empty';
                                },
                                prefixicon: Icon(IconBroken.User),
                                hint: 'bio',
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
