import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/layout/cubit/social_home_cubit.dart';
import 'package:social_app/models/notification__chat__model.dart';
import 'package:social_app/modules/chat_screen/chat_screen.dart';
import 'package:social_app/modules/loginscreen/login_screen.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/network/local/Cache_Helper.dart';


void NavigateTo(context, widget) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}

void NavigateToAndKill(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
        (route) => false,

  );
}


void toastMessage ({@required String msg,@required int state})
{
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: stateColor(state),
      textColor: Colors.white,
      fontSize: 16.0
  );
}

Color stateColor(int state)
{
  // 0 for success and 1 for warning and else for error
  if(state == 0)return Colors.green;
  else if (state == 1) return Colors.yellow;
  else return Colors.red;
}

GlobalKey navigatorKey = GlobalKey<NavigatorState>();

BuildContext getCurrentContext()
{
  return navigatorKey.currentContext;
}
void openChatScreen(context,Data data){

  if(uId!=data.receiverUid)
    {
      Cache_Helper.removeData('uid');
      uId=null;
      NavigateToAndKill(context, LoginScreen());
    }else
      {
        NavigateTo(context, ChatScreen(data.name, data.image, data.uid));
    }
}
