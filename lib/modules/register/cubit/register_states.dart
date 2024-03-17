
import '../../../models/login_model.dart';

abstract class ShopRegisterStates {}

class ShopRegisterInitialState extends ShopRegisterStates {
  ShopRegisterInitialState();
}


class ShopRegisterLoadingState extends ShopRegisterStates {}

class ShopRegisterSuccessState extends ShopRegisterStates
{
  final LoginModel loginModel;

  ShopRegisterSuccessState(this.loginModel);

}

class ShopRegisterErrorState extends ShopRegisterStates {
  final String error;

  ShopRegisterErrorState(this.error);
}
class ShopRegChangePasswordVisibilityState extends ShopRegisterStates {}