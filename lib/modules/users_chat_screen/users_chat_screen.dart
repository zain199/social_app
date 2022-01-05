import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_home_cubit.dart';
import 'package:social_app/layout/cubit/social_home_cubit_states.dart';
import 'package:social_app/models/users_chat_model.dart';
import 'package:social_app/modules/chat_screen/chat_screen.dart';
import 'package:social_app/modules/users_chat_screen/cubit/userschat_cubit.dart';
import 'package:social_app/modules/users_chat_screen/cubit/userschat_cubit_states.dart';
import 'package:social_app/shared/widgets/ConditionalListView.dart';

import '../../shared/styles/icon_broken.dart';
import '../../shared/methods.dart';

class UsersChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatUsersCubit()..getUsersChat(),
      child: BlocConsumer<ChatUsersCubit, ChatUsersStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ChatUsersCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text('Users'),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(IconBroken.Search),
                  iconSize: 20.0,
                ),
              ],
            ),
            body: ConditionalBuilder(
              condition: cubit.users.length > 0,
              builder: (context) => ListView.separated(
                itemBuilder: (context, index) =>
                    userItemBuilder(context, cubit.users[index]),
                separatorBuilder: (context, index) => Divider(
                  height: 1.0,
                ),
                itemCount: cubit.users.length,
              ),
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget userItemBuilder(context, UsersChatModel model) {
    return InkWell(
      onTap: () {
        NavigateTo(context, ChatScreen(model.name, model.image, model.uid));
      },
      child: Container(
        height: 95.0,
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(model.image),
              radius: 40.0,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              model.name,
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
