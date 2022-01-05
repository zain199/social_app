import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_home_cubit.dart';
import 'package:social_app/layout/cubit/social_home_cubit_states.dart';
import 'package:social_app/modules/comments_screen/commets_screen.dart';
import 'package:social_app/modules/edit_profile_screen/edit_profile_screen.dart';
import 'package:social_app/modules/new_post/new_post.dart';
import 'package:social_app/modules/profile_screen/cubit/profile_cubit.dart';
import 'package:social_app/modules/profile_screen/cubit/profile_cubit_states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/widgets/ConditionalListView.dart';
import 'package:social_app/shared/widgets/SubTiltleText.dart';
import 'package:social_app/shared/widgets/UserCoverImage.dart';

import '../../shared/methods.dart';
import '../../shared/widgets/ImageViewer.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialHomeCubit, SocialHomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = SocialHomeCubit.get(context).model;
        var cubit = SocialHomeCubit.get(context);
        return BlocProvider(
          create: (context) => ProfileCubit()..getUserPosts(),
          child: BlocConsumer<ProfileCubit,ProfileCubitStates>(
            listener: (context, state) {
            },
            builder: (context, state) {
              var profileCubit  = ProfileCubit.get(context);
              return Scaffold(
                extendBody: true,
                appBar: AppBar(
                  title: Text('Profile'),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(IconBroken.Search),
                      iconSize: 20.0,
                    ),
                    IconButton(
                      onPressed: () {
                        profileCubit.logout(context);
                      },
                      icon: Icon(IconBroken.Logout),
                      iconSize: 20.0,
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      UserCoverImage(model),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '${model.name}',
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                      Text(
                        '${model.bio}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text(
                                      '100',
                                      style: Theme.of(context).textTheme.subtitle2,
                                    ),
                                    Text(
                                      'Posts',
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                                onTap: () {},
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text(
                                      '265',
                                      style: Theme.of(context).textTheme.subtitle2,
                                    ),
                                    Text(
                                      'Photos',
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                                onTap: () {},
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text(
                                      '10k',
                                      style: Theme.of(context).textTheme.subtitle2,
                                    ),
                                    Text(
                                      'Followers',
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                                onTap: () {},
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text(
                                      '64',
                                      style: Theme.of(context).textTheme.subtitle2,
                                    ),
                                    Text(
                                      'Followings',
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  NavigateTo(context, NewPostScreen());
                                },
                                child: Text('Add Post'),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            OutlinedButton(
                              onPressed: () {
                                NavigateTo(context, EditProfileScreen());
                              },
                              child: Icon(IconBroken.Edit),
                            ),
                          ],
                        ),
                      ),
                      ConditionalBuilder(
                        fallback: (context) => Center(child: Column(
                          children: [
                            SubTitleText(text: 'No Posts From You Untill Now'),
                            SizedBox(height: 50,),
                          ],
                        ),),
                        builder: (context) => ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: profileCubit.posts.length,
                          separatorBuilder: (context, index) => SizedBox(height: 10.0,),
                            itemBuilder:(context, index) =>  postBuilder(context,index),
                        ),
                        condition: (cubit.model!=null && profileCubit.posts.length>0 && cubit.comments.length>0),

                      ),

                      SizedBox(height: 15.0),
                    ],
                  ),

                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget postBuilder(context,index) {
    var cubit = SocialHomeCubit.get(context);
    var profileCubit = ProfileCubit.get(context);
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        cubit.model.image),
                    radius: 25.0,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              cubit.model.name,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.check_circle_sharp,
                              color: Colors.blue,
                              size: 18.0,
                            )
                          ],
                        ),
                        Text(
                          profileCubit.posts[index].dateTime,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      if (cubit.model.uid == profileCubit.posts[index].uid)
                      {cubit.deletePost(index, cubit.postId[index]);profileCubit.deletePost(index);}
                      else
                        toastMessage(
                            msg: 'you can not delete otherone post',
                            state: 2);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                color: defColor,
                height: 2.0,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                profileCubit.posts[index].text,
                style: TextStyle(height: 1.5),
              ),
              SizedBox(height: 10.0),
              SizedBox(
                height: 10.0,
              ),
              if (profileCubit.posts[index].postImage != '')
                Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5.0,
                  child: GestureDetector(
                    onTap: () {
                      NavigateTo(
                          context, ImageViewer(profileCubit.posts[index].postImage));
                    },
                    child: InkWell(
                      onTap: () {
                        NavigateTo(
                            context, ImageViewer(profileCubit.posts[index].postImage));
                      },
                      child: Image(
                        height: 350.0,
                        width: double.infinity,
                        image: CachedNetworkImageProvider(
                          profileCubit.posts[index].postImage,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      child: Row(
                        children: [
                          if(cubit.myLikes[cubit.postId[index]])
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),

                          if(!cubit.myLikes[cubit.postId[index]])
                            Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                            ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('${cubit.likes[cubit.postId[index]]}'),
                        ],
                      ),
                      onPressed: () {
                        cubit.selectedPostId = cubit.postId[index];
                        if(cubit.myLikes[cubit.postId[index]])
                          cubit.unLike();
                        else
                          cubit.like();
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            IconBroken.Chat,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('${cubit.comments[cubit.postId[index]]} comments'),
                        ],
                      ),
                      onPressed: () {
                        showBottomSheet(
                          context: context,
                          builder: (context)=> CommentsScreen(cubit.postId[index],cubit.likes[cubit.postId[index]]),
                        );
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              Divider(
                color: defColor,
                height: 2.0,
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                    CachedNetworkImageProvider(cubit.model.image),
                    radius: 18.0,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(13.0),
                                  topLeft: Radius.circular(13.0),
                                )),
                            child: TextFormField(

                              onFieldSubmitted: (value) {
                                if(cubit.commentControler.text!='')
                                {
                                  cubit.selectedPostId=cubit.postId[index];
                                  cubit.sendComment(cubit.commentControler.text);
                                  cubit.commentControler.text='';
                                }
                              },
                              controller: cubit.commentControler,
                              textAlignVertical: TextAlignVertical.top,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 15.0),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 5.0),
                                hintText: 'Write your Comment here........ ',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(13.0),
                                bottomRight: Radius.circular(13.0)

                            ),
                          ),
                          child: IconButton(

                            onPressed: () {
                              if(cubit.commentControler.text!='')
                              {
                                cubit.selectedPostId=cubit.postId[index];
                                cubit.sendComment(cubit.commentControler.text);
                                cubit.commentControler.text='';
                              }
                            },
                            icon: Icon(IconBroken.Send),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  }


}
