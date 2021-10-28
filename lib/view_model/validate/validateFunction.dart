import 'package:cotafer_server_status/view/screen/dashboard/dashboard.dart';
import 'package:cotafer_server_status/view/widget/showLoadingDialog.dart';
import 'package:cotafer_server_status/view_model/bloc/debouncer/debouncer.dart';
import 'package:cotafer_server_status/view_model/bloc/textField_bloc/TextFieldEvent.dart';
import 'package:cotafer_server_status/view_model/bloc/textField_bloc/TextFieldState.dart';
import 'package:cotafer_server_status/view_model/service/auth/loginService.dart';
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
  pushNavigator(emailState, passwdState, context, { signInBloc }) async {
    if(passwd !='' && emailaddress != ''){
      if (checkBeforePushNavigator(emailState, passwdState)) {
        fromKey.currentState!.save();
        ShowLoadingDialog(context).showLoaderDialog();

        await Future.delayed(Duration(milliseconds: 1000));
        Navigator.pop(context);
        try {
            fromKey.currentState!.save();
            _rememberMe(emailaddress, passwd, checkBox);
        } catch (e) {
          print('error $e');
        }
        try{
        if (await LoginService.getAuthorizeToken(emailaddress, passwd) != null){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashBoardPage()));
        }else{
          signInBloc!.add(SubmitEvent(textFieldError: TextFieldError.Invalid));
        }
        }catch(e){print('error: $e');}
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

  validateErrorMessage(_emailState, _passwdState , _signInState) {
    if (emailErrorMessage(_emailState) != '') {
      return emailErrorMessage(_emailState);
    } else if (_passwdErrorMessage(_passwdState) != '') {
      return _passwdErrorMessage(_passwdState);
    } else if (_signInErrorMessage(_signInState) != '') {
      return _signInErrorMessage(_signInState);
    } else
      return '';
  }

  emailErrorMessage(TextFieldState state) {
    if (!checkValidation(state)) {
      return 'Please input Email Address correctly';
    } else if (state.textFieldError == TextFieldError.ApiRespone){
      return 'Your login detail didn’t match our record. Please double check and try again.';
    } else {
      return '';
    }
  }

  _passwdErrorMessage(TextFieldState state) {
    if (!checkValidation(state)) {
      return 'Please input your Password correctly';
    } else if (state.textFieldError == TextFieldError.ApiRespone) {
      return 'Your login detail didn’t match our record. Please double check and try again.';
    } else {
      return '';
    }
  }
  
  _signInErrorMessage(TextFieldState state) {
    if (!checkValidation(state)) {
      return 'Your username and your password is not correct';
    } else if (state.textFieldError == TextFieldError.ApiRespone) {
      return 'Please check your connection again before Sign In';
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
      prefs.setString('username', _email);
      prefs.setString('password', _passwd);
    } else {
      prefs.setString('username', '');
      prefs.setString('password', '');
    }
  }
}

