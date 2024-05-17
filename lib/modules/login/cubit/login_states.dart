
import '../../../models/login_model.dart';

abstract class NoteLoginStates {}

class ShopLoginInitialState extends NoteLoginStates {}


class ShopLoginLoadingState extends NoteLoginStates {}

class ShopLoginSuccessState extends NoteLoginStates
{
  final LoginModel loginModel;

  ShopLoginSuccessState(this.loginModel);

}

class ShopLoginErrorState extends NoteLoginStates {
  final String error;

  ShopLoginErrorState(this.error);
}
class ShopChangePasswordVisibilityState extends NoteLoginStates {}