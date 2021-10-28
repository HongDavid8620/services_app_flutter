import 'dart:async';
import 'package:cotafer_server_status/view_model/bloc/textField_bloc/TextFieldEvent.dart';
import 'package:cotafer_server_status/view_model/bloc/textField_bloc/TextFieldState.dart';
import 'package:cotafer_server_status/view_model/bloc/textField_bloc/TextFieldValidation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextFieldBloc extends Bloc<TextFieldEvent, TextFieldState> with TextFieldValidation {
  TextFieldBloc() : super(TextFieldState());

  passwordValidation(field) {
    if (this.isFieldEmpty(field) || field.length > 30)
      return true;
    else
      return false;
  }

  //check empty and Invalide
  emailInValidation(field) {
    if (this.isFieldEmpty(field) || !emailValidate(field)) {
      return true;
    } else {
      return false;
    }
  }

  int i = 0;
  @override
  Stream<TextFieldState> mapEventToState(TextFieldEvent event) async* {
    //event check if empty and change or not
    if (event is TextFieldOnChangeEvent) {
      try {
        yield TextFieldState(textFieldError: TextFieldError.Waiting);
        //will check and return invalid for email if it's a Email text
        //event have an Email agurment

        if (event.email != null) {
          if (!emailInValidation(event.email)) {
            yield TextFieldState(textFieldError: TextFieldError.Invalid);
            return;
          }
        } else if (event.number != null) {
          if (!numberValidate(event.text)) {
            yield TextFieldState(textFieldError: TextFieldError.Invalid);
            return;
          }
        } else {
          //check Empty
          if (this.isFieldEmpty(event.text)) {
            yield TextFieldState(textFieldError: TextFieldError.Empty);
            return;
          }
          //check name no number ,symbol
          if (!nameValidate(event.text)) {
            yield TextFieldState(textFieldError: TextFieldError.Invalid);
            return;
          }
        }
        //check change or not change
        if (event.text != event.previousText) {
          yield TextFieldState(textFieldError: TextFieldError.Changed);
          return;
        } else {
          yield TextFieldState(textFieldError: TextFieldError.Nothing);
          return;
        }
      } catch (e) {
        print('changed error $e');
      }
    }

    //event check if not an Email text
    if (event is TextFieldCheckSingInEvent) {
      //validation empty for both mail
      if (emailInValidation(event.email) && passwordValidation(event.passwd)) {
        yield TextFieldState(textFieldError: TextFieldError.Invalid);
      } else {
        yield TextFieldState(textFieldError: TextFieldError.Validate);
      }
    }

    if (event is TextFieldNewPasswdEvent) {
      if (event.newPasswd == event.oldPasswd) {
        yield TextFieldState(textFieldError: TextFieldError.InvalidOldPasswd);
        return;
      } else {
        yield TextFieldState(textFieldError: TextFieldError.Validate);
        return;
      }
    }

    //event check validation password
    if (event is TextFieldPasswordEvent) {
      if (!this.validateWithSpecialChar(event.newPasswd)) {
        yield TextFieldState(textFieldError: TextFieldError.InvalidPasswd);
        return;
      } else {
        yield TextFieldState(textFieldError: TextFieldError.Validate);
        return;
      }
    }

    //event check if the retype same or not
    if (event is TextFieldRetypeEvent) {
      if (event.retypePasswd == event.newPasswd) {
        yield TextFieldState(textFieldError: TextFieldError.Validate);
        return;
      } else {
        yield TextFieldState(textFieldError: TextFieldError.Invalid);
        return;
      }
    }

    //event check password Empty
    if (event is PasswordCheckEmptyEvent) {
      yield TextFieldState(textFieldError: passwordValidation(event.field) ? TextFieldError.Invalid : TextFieldError.Validate);
    }

    //event check email Empty and Validation
    if (event is EmailCheckEvent) {
      yield TextFieldState(textFieldError: emailInValidation(event.field) ? TextFieldError.Invalid : TextFieldError.Validate);
    }

    //event check pin Validation
    if (event is PinCheckEvent) {
      if (pinValidate(event.field)) {
        yield TextFieldState(textFieldError: TextFieldError.Validate);
      } else {
        yield TextFieldState(textFieldError: TextFieldError.Invalid);
      }
    }

    //event use for navigation
    if (event is SubmitEvent) {
      if (event.textFieldError == TextFieldError.Validate) {
        yield TextFieldState(textFieldError: TextFieldError.Validate);
      }
      else if (event.textFieldError == TextFieldError.Invalid) {
        yield TextFieldState(textFieldError: TextFieldError.Invalid);
      }
    }
  }
}
