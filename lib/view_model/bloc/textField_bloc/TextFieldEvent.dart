import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldState.dart';

abstract class TextFieldEvent {}

class TextFieldOnChangeEvent extends TextFieldEvent {
  final String previousText;
  final String? text;
  final String? email;
  final String? number;
  TextFieldOnChangeEvent({this.number, this.email, this.text:'', this.previousText:''});
}

class TextFieldCheckSingInEvent extends TextFieldEvent {
  final String email;
  final String passwd;
  TextFieldCheckSingInEvent({required this.email,this.passwd:''});
}

class TextFieldRetypeEvent extends TextFieldEvent {
  final String? newPasswd;
  final String? retypePasswd;
  TextFieldRetypeEvent({this.retypePasswd, this.newPasswd});
}

class TextFieldNewPasswdEvent extends TextFieldEvent {
  final String? oldPasswd;
  final String? newPasswd;
  TextFieldNewPasswdEvent({this.oldPasswd, this.newPasswd});
}

class PasswordCheckEmptyEvent extends TextFieldEvent {
  final String? field;
  PasswordCheckEmptyEvent({this.field});
}

class PinCheckEvent extends TextFieldEvent {
  final String? field;
  PinCheckEvent({this.field});
}

class EmailCheckEvent extends TextFieldEvent {
  final String? field;
  EmailCheckEvent({this.field});
}

class SubmitEvent extends TextFieldEvent {
  final TextFieldError? textFieldError;
  SubmitEvent({this.textFieldError});
}


