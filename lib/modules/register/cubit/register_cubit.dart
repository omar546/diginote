import 'package:diginotefromtodo/modules/register/cubit/register_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../models/login_model.dart';
import '../../../shared/network/end_points.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates>{
  ShopRegisterCubit(super.initialState);

static ShopRegisterCubit get(context) => BlocProvider.of(context);

late LoginModel loginModel;

void userRegister({
  required String email,
  required String name,
  required String phone,
  required String password,
})
{
  emit(ShopRegisterLoadingState());

  // DioHelper.postData(url: REGISTER, data:
  // {
  //  'name':name,
  //  'email':email,
  //   'password':password,
  //   'phone':phone,
  // }).then((value){
  //   if (kDebugMode) {
  //     print(value.data);
  //   }
  //   loginModel = LoginModel.formJson(value.data);
  //   emit(ShopRegisterSuccessState(loginModel));
  // }).catchError((error){
  //   if (kDebugMode) {
  //     print(error.toString());
  //   }
  //   emit(ShopRegisterErrorState(error.toString()));
  // });
}
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(ShopRegChangePasswordVisibilityState());
  }


}
