
import '../../../models/login_model.dart';

abstract class NoteLoginStates {}

class NoteLoginInitialState extends NoteLoginStates {}


class NoteLoginLoadingState extends NoteLoginStates {}

class NoteLoginSuccessState extends NoteLoginStates
{
  final LoginModel loginModel;

  NoteLoginSuccessState(this.loginModel);

}

class NoteLoginErrorState extends NoteLoginStates {
  final String error;

  NoteLoginErrorState(this.error);
}
class NoteChangePasswordVisibilityState extends NoteLoginStates {}
class NoteChangeAgreement extends NoteLoginStates {}