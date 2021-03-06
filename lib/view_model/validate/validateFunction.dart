import 'package:services_flutter/view/screen/dashboard/dashboard.dart';
import 'package:services_flutter/view/widget/showLoadingDialog.dart';
import 'package:services_flutter/view_model/bloc/debouncer/debouncer.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldEvent.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldState.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInFunction {
  final checkBox;
  final fromKey;
  final passwordValidateBloc;
  final emailaddress;
  final passwd;
  final emailValidateBloc;
  SignInFunction({this.checkBox, this.fromKey, this.passwordValidateBloc, this.emailaddress, this.passwd, this.emailValidateBloc});

  checkBeforePushNavigator(emailState, passwdState) {
    // if _emailaddress = '' ,there are no remember and no value in textfield for the first open
    if (checkValidation(emailState) &&
        checkValidation(passwdState) &&
        (emailaddress != '' && passwd != '')) {
      return true;
    } else if (passwdState.textFieldError != TextFieldError.Nothing &&
        checkValidation(emailState) &&
        checkValidation(passwdState)) {
      return true;
    } else {
      return false;
    }
  }

  //On press sign in button
  pushNavigator(emailState, passwdState, context) async {
    if(passwd !='' && emailaddress != ''){
      // print('state1: ${emailState.textFieldError}');
      // print('state2: ${passwdState.textFieldError}');
      if (checkBeforePushNavigator(emailState, passwdState)) {
        fromKey.currentState!.save();
        ShowLoadingDialog(context).showLoaderDialog();

      print('checked: $emailaddress $passwd');
        await Future.delayed(Duration(milliseconds: 1000));
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashBoardPage()));
        try {
          if (checkBox) {
            fromKey.currentState!.save();
            _rememberMe(emailaddress, passwd, false);
          } else {
            _rememberMe(emailaddress, passwd, true);
          }
        } catch (e) {
          print('error $e');
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashBoardPage()));
      }
    }
  }

  //SignInFunction
  signInEvent(_email, _passwd) {
    emailValidateBloc!.add(TextFieldCheckSingInEvent(email: _email, passwd: _passwd));
  }

  emailChangeEvent(_email, {delay}) {
    final _debouncer = Debouncer(milliseconds: delay ?? 0);
    _debouncer.run(() {
      emailValidateBloc!.add(EmailCheckEvent(field: _email!));
    });
  }

  passwdChangeEvent(_passwd) {
    passwordValidateBloc!.add(PasswordCheckEmptyEvent(field: _passwd!));
  }

  validateErrorMessage(_emailState, _passwdState) {
    if (emailErrorMessage(_emailState) != '') {
      return emailErrorMessage(_emailState);
    } else if (_passwdErrorMessage(_passwdState) != '') {
      return _passwdErrorMessage(_passwdState);
    } else
      return '';
  }

  emailErrorMessage(TextFieldState state) {
    if (!checkValidation(state)) {
      return 'Please input Email Address correctly';
    } else if (state.textFieldError == TextFieldError.ApiRespone){
      return 'Your login detail didn???t match our record. Please double check and try again.';
    } else {
      return '';
    }
  }

  _passwdErrorMessage(TextFieldState state) {
    if (!checkValidation(state)) {
      return 'Please input your Password correctly';
    } else if (state.textFieldError == TextFieldError.ApiRespone) {
      return 'Your login detail didn???t match our record. Please double check and try again.';
    } else {
      return '';
    }
  }
  
  checkValidation(TextFieldState state) {
    if (state.textFieldError == TextFieldError.Invalid ) {
      return false;
    } else {
      return true;
    }
  }


  _rememberMe(_email, _passwd, bool _checkBox) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_checkBox) {
      prefs.setString('username', 'null');
      prefs.setString('password', 'null');
    } else {
      prefs.setString('username', _email);
      prefs.setString('password', _passwd);
    }
  }
}

