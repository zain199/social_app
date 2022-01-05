import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/users_chat_model.dart';
import 'package:social_app/modules/chat_screen/chat_screen.dart';
import 'package:social_app/modules/users_chat_screen/cubit/userschat_cubit_states.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/methods.dart';

class ChatUsersCubit extends Cubit<ChatUsersStates> {
  ChatUsersCubit() : super(ChatUsersInitState());

  static ChatUsersCubit get(context) => BlocProvider.of(context);


  List<UsersChatModel> users=[];

  void getUsersChat() {
    users=[];
    emit(ChatUsersGetUsersChatLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if(UsersChatModel.fromJson(element.data()).uid!=uId)
          users.add(UsersChatModel.fromJson(element.data()));
      });
      emit(ChatUsersGetUsersChatSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(ChatUsersGetUsersChatErrorState());
    });
  }



}