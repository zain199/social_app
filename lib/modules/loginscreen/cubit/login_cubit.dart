import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/loginscreen/cubit/login_cubit_states.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/network/local/Cache_Helper.dart';
import 'package:social_app/shared/methods.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;

  void setVis() {
    isPassword = !isPassword;
    emit(SocialLoginChangeVisPassState());
  }


  void userLogin({@required context,@required email, @required password}) {
    emit(SocialLoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      if(value.user.uid!=null)
        {
          //toastMessage(msg: value.user.email, state: 0);
          uId = value.user.uid;
          Cache_Helper.setData('uid', uId);
          NavigateToAndKill(context, SocialLayout());
        }
      emit(SocialLoginSuccessState(true));
    }).catchError((onError){
      toastMessage(msg: onError.toString(), state: 2);
      emit(SocialLoginErrorState());
    });


  }
}
