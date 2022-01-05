
import 'package:conditional_builder/conditional_builder.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_home_cubit.dart';
import 'package:social_app/layout/cubit/social_home_cubit_states.dart';
import 'package:social_app/modules/new_post/new_post.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/shared/methods.dart';


class SocialLayout extends StatelessWidget {

 bool first =false;

  @override
  Widget build(BuildContext context) {


     return BlocConsumer<SocialHomeCubit, SocialHomeStates>(

       listener: (context, state) {

       },
       builder: (context, state) {
         var cubit = SocialHomeCubit.get(context);
         if(!first){
           cubit.getUserData();
           cubit.getPosts();
           SocialHomeCubit.bottomNavItemIndex=0;
           first=true;
         }
         return Scaffold(
           extendBody: true,
           bottomNavigationBar:  CurvedNavigationBar(

             color: Colors.grey[300],
             buttonBackgroundColor: Colors.orange[300],
             backgroundColor: Colors.transparent,
             animationDuration: Duration(milliseconds: 200),
             height: 45.0,
             items: [
               Icon( IconBroken.Home,size:30.0,),
               Icon(IconBroken.Chat,size: 30.0,),
               Icon(IconBroken.Plus,size:30.0,),
               Icon(IconBroken.User,size: 30.0,),
             ],
             onTap: (index) {
               cubit.setBottomNavItemIndex(index);
             },

             index:  SocialHomeCubit.bottomNavItemIndex ,

           ),

           body:ConditionalBuilder(
             condition: cubit.model!=null,
             builder: (context) =>cubit.screens[SocialHomeCubit.bottomNavItemIndex] ,
             fallback: (context)=>Center(child: CircularProgressIndicator()),
           ),
         );
       },
     );
   }
  }



