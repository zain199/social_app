import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_home_cubit.dart';
import 'package:social_app/layout/cubit/social_home_cubit_states.dart';
import 'package:social_app/modules/comments_screen/commets_screen.dart';
import 'package:social_app/shared/widgets/DefualtTextFormField.dart';
import 'package:social_app/shared/widgets/ImageViewer.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/methods.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = SocialHomeCubit.get(context);
    return BlocConsumer<SocialHomeCubit, SocialHomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Home'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(IconBroken.Search),
                iconSize: 20.0,
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async{
              return cubit.getPosts();
            },
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // THE COVER IMAGE
                  Container(
                    height: 200.0,
                    width: double.infinity,
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5.0,
                      child: Image(
                        image: CachedNetworkImageProvider(
                            'https://image.freepik.com/free-photo/hand-drawn-illustrations-social-media_1134-78.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  //POST LAYOUT
                  ConditionalBuilder(
                    condition: cubit.model != null && cubit.posts.length > 0&&cubit.comments.length>0&&cubit.likes.length>0,
                    builder: (context) {
                      cubit.setDeviceToken();
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) =>
                            postBuilder(context, index),
                        separatorBuilder: (context, index) => SizedBox(
                          height: 10.0,
                        ),
                        itemCount: cubit.posts.length,
                      );
                    },
                    fallback: (context) => Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                  SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget postBuilder(context, index) {
    var cubit = SocialHomeCubit.get(context);
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
                      cubit.posts[index].postUserImage),
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
                            cubit.posts[index].postUserName,
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
                        cubit.posts[index].dateTime,
                        style: Theme
                            .of(context)
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
                    if (cubit.model.uid == cubit.posts[index].uid)
                      cubit.deletePost(index, cubit.postId[index]);
                    else
                      toastMessage(
                          msg: 'you can not delete otherone post', state: 2);
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
              cubit.posts[index].text,
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 10.0),
            SizedBox(
              height: 10.0,
            ),
            if (cubit.posts[index].postImage != '')
              Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 5.0,
                child: GestureDetector(
                  onTap: () {
                    NavigateTo(
                        context, ImageViewer(cubit.posts[index].postImage));
                  },
                  child: InkWell(
                    onTap: () {
                      NavigateTo(
                          context, ImageViewer(cubit.posts[index].postImage));
                    },
                    child: Image(
                      height: 350.0,
                      width: double.infinity,
                      image: CachedNetworkImageProvider(
                        cubit.posts[index].postImage,
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
                        Text('${cubit.comments[cubit.postId[index].toString()]} comments'),
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
