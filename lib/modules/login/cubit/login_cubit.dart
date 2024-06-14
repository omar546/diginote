import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../models/login_model.dart';
import '../../../shared/network/end_points.dart';
import '../../../shared/network/remote/dio_helper.dart';
import 'login_states.dart';

class NoteLoginCubit extends Cubit<NoteLoginStates>{
  NoteLoginCubit(super.initialState);

static NoteLoginCubit get(context) => BlocProvider.of(context);

late LoginModel loginModel;
  bool agreement = false;

void userLogin({
  required String email,
  required String password,
})
{
  emit(NoteLoginLoadingState());

  DioHelper2.postData(url: LOGIN, data:
  {
   'email':email,
    'password':password,
  }).then((value){
    if (kDebugMode) {
      print(value.data);
    }
    loginModel = LoginModel.formJson(value.data);
    emit(NoteLoginSuccessState(loginModel));
  }).catchError((error){
    if (kDebugMode) {
      print(error.toString());
    }
    emit(NoteLoginErrorState(error.toString()));
  });
}
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(NoteChangePasswordVisibilityState());
  }
  void changeAgreement(){
    agreement = !agreement;
    emit(NoteChangeAgreement());
  }


}
