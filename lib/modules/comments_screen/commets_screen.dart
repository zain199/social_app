import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/comments_screen/cubit/comments_cubit.dart';
import 'package:social_app/modules/comments_screen/cubit/comments_cubit_states.dart';
import 'package:social_app/shared/methods.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/widgets/Comment.dart';
import 'package:social_app/shared/widgets/SubTiltleText.dart';
import 'package:social_app/shared/widgets/TitleText.dart';

class CommentsScreen extends StatelessWidget {

  String postId;
  int likes;
  bool first=true;
  CommentsScreen(this.postId,this.likes);

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
     create: (context) => CommentsCubit(),
     child: BlocConsumer<CommentsCubit, CommentsCubitStates>(
        listener: (context, state) {
        },
        builder: (context, state) {
          var cubit = CommentsCubit.get(context);

          if(first)
          {
            cubit.setSelectedPostId(postId);
           cubit. getComments();
           cubit.setLikes(this.likes);
            first=false;
          }

        return Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Column(
              children: [
                Text('${cubit.likes} Likes'),
                Divider(
                  color: defColor,
                  height: 1.0,
                  thickness: 1.0,
                ),
                ConditionalBuilder(
                  condition: cubit.comments.length>0,
                  builder: (context) => Expanded(
                    child: ListView.separated(
                        itemBuilder:(context, index) => InkWell(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (_)=>AlertDialog(
                                title: TitleText('Warning'),
                                content: Container(
                                  child: Column(
                                    children: [
                                      Expanded(child: SubTitleText(text: 'Do You Want To Delete This Comment',)),
                                      SizedBox(height: 10.0),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: MaterialButton(
                                              onPressed: (){
                                                cubit.deleteComment(index);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Yes'),
                                              color: defColor,

                                            ),
                                          ),
                                          SizedBox(width: 10.0,),
                                          Expanded(
                                            child: MaterialButton(
                                              onPressed: (){Navigator.pop(context);},
                                              child: Text('No'),
                                              color: defColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  width: 120.0,
                                  height: 100.0,
                                ),
                              )
                            );
                          },
                          child: Comment(
                            userImage: cubit.comments[index].image,
                            userName: cubit.comments[index].name,
                            textComment: cubit.comments[index].textComment,
                            commentTime: cubit.comments[index].commentTime,
                          ),
                        ),
                        separatorBuilder:(context, index) =>SizedBox(height: 10.0,) ,
                        itemCount: cubit.comments.length
                    ),
                  ),
                  fallback: (context) => Expanded(child: Center(child: SubTitleText(text:'No Comments For This Post'))),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(13.0),
                                topLeft: Radius.circular(13.0),
                              )),
                          child: TextFormField(
                            onTap: () {
                                cubit.keyboard=true;
                            },
                            onFieldSubmitted: (value) {
                              cubit. keyboard=false;
                              if(cubit.commentControler.text!='')
                                {

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
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(13.0),
                              topRight: Radius.circular(13.0),
                            )),
                        child: IconButton(
                          onPressed: () {
                            if(cubit.commentControler.text!='')
                              {
                                cubit.sendComment(cubit.commentControler.text);
                                cubit.commentControler.text='';
                                Navigator.pop(context);
                              }
                          },
                          color: defColor,
                          icon: Icon(IconBroken.Send),
                        ),
                      ),
                    ],
                  ),
                ),
                if(!cubit.keyboard)
                  SizedBox(height: 50.0,),
              ],
            ),
          );
        }
     )
    );
  }
}
