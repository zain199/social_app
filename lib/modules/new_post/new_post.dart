import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_home_cubit.dart';
import 'package:social_app/layout/cubit/social_home_cubit_states.dart';
import 'package:social_app/modules/new_post/cubit/new_post_cubit.dart';
import 'package:social_app/modules/new_post/cubit/newpost_cubit_states.dart';
import 'package:social_app/shared/widgets/ImageViewer.dart';
import 'package:social_app/shared/methods.dart';


class NewPostScreen extends StatelessWidget {
  var keys = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{
        NewPostCubit.get(context).cancelPickPostImage();
        return true ;
      },
      child: BlocConsumer<SocialHomeCubit,SocialHomeStates>(
        listener: (context, state) {

        },
        builder: (context, state) {

          var cubit = SocialHomeCubit.get(context);
          return BlocProvider(
            create: (context) => NewPostCubit(),
            child: BlocConsumer<NewPostCubit,NewPostCubitStates>(
              listener: (context, state) {
              },
              builder: (context, state) {
                var newPostCubit = NewPostCubit.get(context);
                return Scaffold(
                  appBar: AppBar(
                    title: Text('New Post'),
                    actions: [
                      TextButton(onPressed: (){

                        if(keys.currentState.validate())
                        {
                          newPostCubit.checkPost(cubit.model.name, cubit.model.image,context);
                        }

                      }, child: Text('POST')),
                      TextButton(
                        child: Text('Add Photo'),
                        onPressed: (){
                          newPostCubit.pickPostImage().then((value) {
                          }).catchError((onError){
                            toastMessage(msg: 'something went wrong', state: 2);
                          });
                        },
                      ),
                    ],
                  ),
                  body: Form(
                    key: keys,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(state is NewPostUploadingPostImageLoadingState)
                              LinearProgressIndicator(),
                            SizedBox(height: 10.0,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(cubit.model.image),
                                  radius: 25.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child:Row(
                                    children: [
                                      Text(
                                        cubit.model.name,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0,),
                            Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  scrollPhysics: BouncingScrollPhysics(),
                                  controller: newPostCubit.postText,
                                  maxLines: null,
                                  minLines: 1,
                                  validator: (String value)
                                  {
                                    if(value.isEmpty)
                                      return 'Post can not be empty';
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'what is on your mind ............',
                                    border: InputBorder.none,
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                if(newPostCubit.filePostImage!=null)
                                  Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Card(
                                        margin: EdgeInsets.zero,
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        elevation: 5.0,
                                        child: GestureDetector(
                                          onTap: (){
                                            NavigateTo(context, ImageViewer(newPostCubit.filePostImage));
                                          },
                                          child: Image(
                                            height: 350.0,
                                            width: double.infinity,
                                            image: FileImage(newPostCubit.filePostImage),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.grey[800],
                                        radius: 12.0,
                                        child: Center(
                                          child: GestureDetector(
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            onTap: (){
                                              newPostCubit.cancelPickPostImage();
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                SizedBox(height: 40.0,),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
