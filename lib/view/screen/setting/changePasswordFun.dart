import 'package:services_flutter/view/screen/setting/changePassword.dart';
import 'package:services_flutter/view/widget/showLoadingDialog.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldEvent.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldState.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/textField_bloc.dart';
import 'package:flutter/widgets.dart';

class ChangePasswordFunction {
  final _checkOldPasswdFocus;
  final oldPasswd;
  final _oldPasswordFieldBloc;
  final _checkNewPasswdFocus;
  final _oldNewPasswdFieldBloc;
  final _newPasswdFieldBloc;
  final _checkRetypePasswdFocus;
  final _retypePasswdFieldBloc;
  late final pwFieldFocus;
  final oldPassFucus;
  final _signInListenerBloc;
  final newPassFucus;
  final retypePassFucus;
  final newPasswd;
  final retypeNewPasswd;

  ChangePasswordFunction(this._checkOldPasswdFocus, this.oldPasswd, this._oldPasswordFieldBloc, this._checkNewPasswdFocus, this._oldNewPasswdFieldBloc, this._newPasswdFieldBloc, this._checkRetypePasswdFocus, this._retypePasswdFieldBloc, this.pwFieldFocus, this.oldPassFucus, this._signInListenerBloc, this.newPassFucus, this.retypePassFucus, this.newPasswd, this.retypeNewPasswd);

    //call this funtion in focus widget when has focus
  void checkChangeFocus({bool? oldPass, bool? newPass, bool? retypePass}) {
    // print('checked : $_checkOldPasswdFocus $_checkNewPasswdFocus $_checkRetypePasswdFocus');

    if (_checkOldPasswdFocus && oldPass != true) {
      // checkNewPasswdOldPasswd(_oldNewPasswdFieldBloc!);
      passwdCheckEmptyEvent(oldPasswd, _oldPasswordFieldBloc);
    }
    if (_checkNewPasswdFocus && newPass != true) {
      checkNewPasswdOldPasswd(_oldNewPasswdFieldBloc!);
      checkNewPassword(_newPasswdFieldBloc!);
    }
    if (_checkRetypePasswdFocus && retypePass != true) {
      checkRetype(_retypePasswdFieldBloc!);
    }
  }

  //get error message
  String passwordErrorMessage(TextFieldState newPasswdState, TextFieldState oldNewPasswdState, TextFieldState oldPasswdState, TextFieldState retypePasswdState) {
    if (oldPasswdState.textFieldError == TextFieldError.Invalid)
      return 'Password input your old Password correctly.';
    else if (oldNewPasswdState.textFieldError == TextFieldError.InvalidOldPasswd)
      return 'Your new password cannot match as your current one. Please try again.';
    else if (newPasswdState.textFieldError == TextFieldError.Error)
      return 'Process failed. Please try again later.';
    else if (newPasswdState.textFieldError == TextFieldError.InvalidPasswd)
      return 'Password requires 6 characters, at least 1 number, 1 letter and 1 capital letter.';
    else if (retypePasswdState.textFieldError == TextFieldError.Invalid) {
      return 'Please retype your new password correctly.';
    } else
      return '';
  }

  onSave(oldPasswdState, newPasswdState, oldNewPasswdState, retypePasswdState,context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    await loading(context);
    passwdCheckEmptyEvent(oldPasswd, _oldPasswordFieldBloc); //check empty
    // print('checked : ${oldPasswdState!.textFieldError == TextFieldError.Validate}');
    if (_checkNewPasswdFocus) {
      checkNewPassword(_newPasswdFieldBloc!); //check validate new password
      checkNewPasswdOldPasswd(_oldNewPasswdFieldBloc!); //check old and new password
      checkRetype(_retypePasswdFieldBloc!); //check retype password and new password
    }
    //check if oldpassword not valide and no focus
    if (pwFieldFocus == null)
      pwFieldFocus = ChangePWFocus.oldpw;
    else if (pwFieldFocus != ChangePWFocus.newpw) pwFieldFocus = ChangePWFocus.nextFocus;

    await Future.delayed(Duration(milliseconds: 100));
    _signInListenerBloc!.add(SubmitEvent(textFieldError: TextFieldError.Validate));
  }

  checkAllValidate({TextFieldState? newPasswdState, TextFieldState? oldPasswdState, TextFieldState? retypePasswdState, TextFieldState? oldNewPasswdState}) {
    if (newPasswdState!.textFieldError == TextFieldError.Validate &&
        oldPasswdState!.textFieldError == TextFieldError.Validate &&
        oldNewPasswdState!.textFieldError == TextFieldError.Validate &&
        retypePasswdState!.textFieldError == TextFieldError.Validate) {
      return true;
    } else {
      return false;
    }
  }

  passwdCheckEmptyEvent(_passwd, bloc) {
    bloc!.add(PasswordCheckEmptyEvent(field: _passwd));
  }

  checkNewPasswdOldPasswd(TextFieldBloc bloc) {
    if (newPasswd != null && oldPasswd != null) {
      bloc.add(TextFieldNewPasswdEvent(newPasswd: newPasswd, oldPasswd: oldPasswd));
    }
  }

  checkRetype(TextFieldBloc bloc) {
    if (newPasswd != null && retypeNewPasswd != null) {
      bloc.add(TextFieldRetypeEvent(newPasswd: newPasswd, retypePasswd: retypeNewPasswd));
    }
  }

  checkNewPassword(TextFieldBloc bloc) {
    // print('checked1 $newPasswd');
    if (newPasswd != null) {
      bloc.add(TextFieldPasswordEvent(newPasswd: newPasswd));
    }
  }

  validateOldPasswd(oldPasswdState) {
    if (oldPasswdState.textFieldError == TextFieldError.Invalid) {
      return true;
    } else {
      return false;
    }
  }

  validateNewPasswd(newPasswdState, oldNewPasswdState, oldPasswdState) {
    if (newPasswdState.textFieldError == TextFieldError.InvalidPasswd || oldNewPasswdState.textFieldError == TextFieldError.InvalidOldPasswd) {
      return true;
    } else {
      return false;
    }
  }

  validateRetypePasswd(newPasswdState, oldNewPasswdState, retypePasswdState, _errorMessage) {
    if (_errorMessage != '' &&
        newPasswdState.textFieldError != TextFieldError.InvalidPasswd &&
        oldNewPasswdState.textFieldError == TextFieldError.Validate &&
        retypePasswdState.textFieldError == TextFieldError.Invalid) {
      return true;
    } else {
      // pwFieldFocus = ChangePWFocus.noFocus;
      return false;
    }
  }

  loading(context) async {
    ShowLoadingDialog(context).showLoaderDialog();
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pop(context);
  }

  changeFocus(oldPasswdState, newPasswdState, oldNewPasswdState, retypePasswdState, _errorMessage) {
    //old
    if (validateOldPasswd(oldPasswdState)) {
      if (pwFieldFocus == ChangePWFocus.oldpw) {
        oldPassFucus.requestFocus();
      }
    } else {
      if (pwFieldFocus == ChangePWFocus.nextFocus) {
        pwFieldFocus = ChangePWFocus.newpw;
      }
    }
    //new
    if (pwFieldFocus == ChangePWFocus.newpw) {
      // print('checked focus: ${newPasswdState.textFieldError} ${oldNewPasswdState.textFieldError} ${oldPasswdState.textFieldError}');
      if (validateNewPasswd(newPasswdState, oldNewPasswdState, oldPasswdState)) {
        newPassFucus.requestFocus();
      } else {
        pwFieldFocus = ChangePWFocus.retypepw;
        // print('checked focus go toretype : $pwFieldFocus');
      }
    }

    //retype
    if (validateRetypePasswd(newPasswdState, oldNewPasswdState, retypePasswdState, _errorMessage)) {
      // print('checked focus go toretype : $pwFieldFocus');
      if (pwFieldFocus == ChangePWFocus.retypepw) {
        retypePassFucus.requestFocus();
      }
    }
  }

}

 