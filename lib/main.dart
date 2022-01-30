import 'package:bloc/bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_home_cubit.dart';
import 'package:social_app/layout/cubit/social_home_cubit_states.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/loginscreen/login_screen.dart';
import 'package:social_app/shared/blocobcerver.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/notifications/fcm_helper.dart';
import 'package:social_app/shared/network/local/Cache_Helper.dart';
import 'package:social_app/shared/network/remote/diohelper.dart';
import 'package:social_app/shared/notifications/notifications.dart';
import 'package:social_app/shared/styles/theme.dart';
import 'package:social_app/shared/methods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await Cache_Helper.init();
  DioHelper.init();
  Fcm_Helper.init();
  Notifications.init();
  MyApp.getInitialData();
  MyApp.checkWhichScreen();

  runApp(DevicePreview(
      enabled: !kReleaseMode, builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  static Widget screen;


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
        create: (context) => SocialHomeCubit(),
        child: BlocConsumer<SocialHomeCubit, SocialHomeStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              useInheritedMediaQuery: true,
              locale: DevicePreview.locale(context),
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              home: screen,
            );
          },
        ));
  }

  static void checkWhichScreen()
  {
    if (uId != null) {
      screen = SocialLayout();
    } else
      screen = LoginScreen();
  }

  static void getInitialData()
  {
    uId = Cache_Helper.getData('uid');
    FirebaseMessaging.instance.getToken().then((value) {token=value;});
  }
}
