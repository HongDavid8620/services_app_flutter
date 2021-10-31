import 'package:services_flutter/view/widget/customButton.dart';
import 'package:services_flutter/view/widget/inputField/inputTextField.dart';
import 'package:services_flutter/view/widget/showLoadingDialog.dart';
import 'package:services_flutter/view/widget/textErrorMessage.dart';
import 'package:services_flutter/view_model/bloc/debouncer/debouncer.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldEvent.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldState.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/textField_bloc.dart';
import 'package:services_flutter/view_model/service/password/changePasswordServicer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ChangePWFocus { oldpw, newpw, retypepw, noFocus, nextFocus }

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var oldPasswd;
  var newPasswd;
  var retypeNewPasswd;
  var _fromKey = GlobalKey<FormState>();

  ChangePWFocus? pwFieldFocus;
  bool _keyboard = false;
  bool _checkOldPasswdFocus = false;
  bool _checkNewPasswdFocus = false;
  bool _checkRetypePasswdFocus = false;

  // use for focus each field
  FocusNode oldPassFucus = new FocusNode();
  FocusNode newPassFucus = new FocusNode();
  FocusNode retypePassFucus = new FocusNode();

  String _errorMessage = '';

  TextFieldBloc? _oldPasswordFieldBloc;
  TextFieldBloc? _oldNewPasswdFieldBloc;
  TextFieldBloc? _newPasswdFieldBloc;
  TextFieldBloc? _retypePasswdFieldBloc;
  TextFieldBloc? _signInListenerBloc;

  @override
  void initState() {
    this._newPasswdFieldBloc = TextFieldBloc();
    this._oldPasswordFieldBloc = TextFieldBloc();
    this._oldNewPasswdFieldBloc = TextFieldBloc();
    this._retypePasswdFieldBloc = TextFieldBloc();
    this._signInListenerBloc = TextFieldBloc();
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordFieldBloc!.close();
    _newPasswdFieldBloc!.close();
    _oldNewPasswdFieldBloc!.close();
    _retypePasswdFieldBloc!.close();
    _signInListenerBloc!.close();
    super.dispose();
  }

  final _debouncer = Debouncer(milliseconds: 100);


  // var changePasswordFunction = ChangePasswordFunction()
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextFieldBloc, TextFieldState>(
        bloc: _oldPasswordFieldBloc,
        builder: (context, oldPasswdState) {
          //BlocBuilder for Newpassword
          return BlocBuilder<TextFieldBloc, TextFieldState>(
              bloc: _newPasswdFieldBloc,
              builder: (context, newPasswdState) {
                //BlocBuilder for Retypepassword
                return BlocBuilder<TextFieldBloc, TextFieldState>(
                    bloc: _retypePasswdFieldBloc,
                    builder: (context, retypePasswdState) {
                      return BlocBuilder<TextFieldBloc, TextFieldState>(
                          bloc: _oldNewPasswdFieldBloc,
                          builder: (context, oldNewPasswdState) {
                            var size = MediaQuery.of(context).viewInsets.bottom;

                            _debouncer.run(() {
                            changeFocus(oldPasswdState, newPasswdState, oldNewPasswdState, retypePasswdState);
                            });

                            if (size != 0) {
                              _keyboard = true;
                            }
                            if (size == 0 && _keyboard) {
                              _keyboard = false;
                              checkChangeFocus();
                            }
                            //set error message
                            _errorMessage = passwordErrorMessage(newPasswdState, oldNewPasswdState, oldPasswdState, retypePasswdState);

                            //check if all field validated tell bloc listener to navigate
                            return BlocListener<TextFieldBloc, TextFieldState>(
                                bloc: _signInListenerBloc,
                                listener: (context, TextFieldState state) async{
                                  if (oldPasswdState.textFieldError == TextFieldError.Validate) {
                                    checkNewPassword(_newPasswdFieldBloc!); //check validate new password
                                    checkNewPasswdOldPasswd(_oldNewPasswdFieldBloc!); //check old and new password
                                    // checkRetype(_retypePasswdFieldBloc!); //check retype password and new password
                                  }

                                  if (checkAllValidate(
                                      newPasswdState    : newPasswdState,
                                      oldNewPasswdState : oldNewPasswdState,
                                      oldPasswdState    : oldPasswdState,
                                      retypePasswdState : retypePasswdState)) {
                                    var msg = await ChangePasswordService.changePassword(oldpassword: oldPasswd, newpassword: newPasswd);

                                    if (msg == 'accepted') {
                                      Navigator.pop(context);
                                      _signInListenerBloc!.close();
                                    }
                                  }
                                  // print('${newPasswdState.textFieldError};${oldPasswdState.textFieldError};${retypePasswdState.textFieldError};${oldNewPasswdState.textFieldError}');
                                },
                                child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      if (size != 0) {
                                        FocusScope.of(context).requestFocus(new FocusNode());
                                        _fromKey.currentState!.save();
                                        pwFieldFocus = ChangePWFocus.noFocus;
                                        checkChangeFocus();
                                      }
                                    },
                                    child: Scaffold(
                                        appBar: AppBar(
                                          leading: IconButton(
                                            icon: Icon(Icons.arrow_back_ios, size: 35, color: Colors.black),
                                            onPressed: () => Navigator.of(context).pop(),
                                          ),
                                          title: Text('Settings'),
                                          centerTitle: true,
                                        ),

                                        //BlocBuilder for Oldpassword
                                        body: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Form(
                                            key: _fromKey,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                //Error Message
                                                TextErrorMessage(
                                                  newMessage: '$_errorMessage',
                                                ),

                                                //Old paaswd
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 25.0),
                                                  child: Focus(
                                                    onFocusChange: (hasFocus) {
                                                      if (hasFocus) {
                                                        setState(() {
                                                          _checkOldPasswdFocus = true;
                                                          pwFieldFocus = ChangePWFocus.noFocus;
                                                          // TappedFieldFocus = ChangePWFocus.oldpw;
                                                          // _hasFocus = true;
                                                        });
                                                        checkChangeFocus(oldPass: true);
                                                      }
                                                    },
                                                    child: InputTextField(
                                                      focusNode: oldPassFucus,
                                                      maxLength: 30,
                                                      password: true,
                                                      validate: validateOldPasswd(oldPasswdState),
                                                      textColor: validateOldPasswd(oldPasswdState) ? Colors.red : Colors.black,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          oldPasswd = value;
                                                        });
                                                      },
                                                      onSaved: (value) {
                                                        setState(() {
                                                          oldPasswd = value;
                                                        });
                                                      },
                                                      text: 'Old password',
                                                    ),
                                                  ),
                                                ),

                                                //New passwd
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 25.0),
                                                  child: Focus(
                                                    onFocusChange: (hasFocus) {
                                                      if (hasFocus) {
                                                        setState(() {
                                                          _checkNewPasswdFocus = true;
                                                          pwFieldFocus = ChangePWFocus.noFocus;
                                                          // TappedFieldFocus = ChangePWFocus.newpw;
                                                          // _hasFocus = true;
                                                        });
                                                        checkChangeFocus(newPass: true);
                                                      }
                                                    },
                                                    child: InputTextField(
                                                        focusNode: newPassFucus,
                                                        maxLength: 30,
                                                        password: true,
                                                        validate: validateNewPasswd(newPasswdState, oldNewPasswdState, oldPasswdState),
                                                        text: 'New password',
                                                        onSaved: (value) {
                                                          setState(() {
                                                            newPasswd = value;
                                                          });
                                                        },
                                                        onChanged: (value) {
                                                          setState(() {
                                                            newPasswd = value;
                                                          });
                                                        },
                                                        textColor: validateNewPasswd(newPasswdState, oldNewPasswdState, oldPasswdState) ? Colors.red : Colors.black),
                                                  ),
                                                ),

                                                //Retype passwd
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 25.0),
                                                  child: Focus(
                                                    onFocusChange: (hasFocus) {
                                                      if (hasFocus) {
                                                        setState(() {
                                                          _checkRetypePasswdFocus = true;
                                                          pwFieldFocus = ChangePWFocus.noFocus;
                                                          // TappedFieldFocus = ChangePWFocus.retypepw;
                                                          // _hasFocus = true;
                                                        });
                                                        checkChangeFocus(retypePass: true);
                                                      }
                                                    },
                                                    child: InputTextField(
                                                      focusNode: retypePassFucus,
                                                      maxLength: 30,
                                                      password: true,
                                                      text: 'Re-type new password',
                                                      onSaved: (value) {
                                                        setState(() {
                                                          retypeNewPasswd = value;
                                                        });
                                                      },
                                                      onChanged: (value) {
                                                        setState(() {
                                                          retypeNewPasswd = value;
                                                        });
                                                      },
                                                      textColor: validateRetypePasswd(newPasswdState,oldNewPasswdState, retypePasswdState) ? Colors.red : Colors.black,
                                                      validate: validateRetypePasswd(newPasswdState,oldNewPasswdState, retypePasswdState),
                                                    ),
                                                  ),
                                                ),

                                                //Button save and cancel
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    CustomButton(
                                                      btText: 'Save',
                                                      btWidth: MediaQuery.of(context).size.width * 0.475 - 10,
                                                      btHieght: 50,
                                                      onPressed: () {
                                                        _fromKey.currentState!.save();
                                                        onSave(oldPasswdState, newPasswdState, oldNewPasswdState, retypePasswdState);
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width * 0.05,
                                                    ),
                                                    CustomButton(
                                                      btColor: Color.fromRGBO(222, 222, 222, 1),
                                                      btTextColor: Colors.indigo,
                                                      btText: 'Cancel',
                                                      btWidth: MediaQuery.of(context).size.width * 0.475 - 10,
                                                      btHieght: 50,
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        FocusScope.of(context).requestFocus(new FocusNode());
                                                        _fromKey.currentState!.reset();
                                                      },
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ))));
                          });
                    });
              });
        });
  }

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

  onSave(oldPasswdState, newPasswdState, oldNewPasswdState, retypePasswdState) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    await loading();
    passwdCheckEmptyEvent(oldPasswd, _oldPasswordFieldBloc); //check empty
    // print('checked : ${oldPasswdState!.textFieldError == TextFieldError.Validate}');
    if (_checkOldPasswdFocus && _checkNewPasswdFocus) {
      checkNewPassword(_newPasswdFieldBloc!); //check validate new password
      checkNewPasswdOldPasswd(_oldNewPasswdFieldBloc!); //check old and new password
      checkRetype(_retypePasswdFieldBloc!); //check retype password and new password
    }
    //check if oldpassword not valide and no focus
      if (pwFieldFocus == null)
        pwFieldFocus = ChangePWFocus.oldpw;
      else if (pwFieldFocus != ChangePWFocus.newpw)
        pwFieldFocus = ChangePWFocus.nextFocus;

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
      if(oldPasswdState.textFieldError != TextFieldError.Invalid)
      return true;
      else return false;
    } else {
      return false;
    }
  }

  validateRetypePasswd( newPasswdState, oldNewPasswdState, retypePasswdState) {
    if (_errorMessage != '' && newPasswdState.textFieldError != TextFieldError.InvalidPasswd && oldNewPasswdState.textFieldError == TextFieldError.Validate && retypePasswdState.textFieldError == TextFieldError.Invalid) {
      return true;
    } else {
      // pwFieldFocus = ChangePWFocus.noFocus;
      return false;
    }
  }

  loading() async {
    ShowLoadingDialog(context).showLoaderDialog();
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pop(context);
  }

  changeFocus(oldPasswdState, newPasswdState, oldNewPasswdState, retypePasswdState) {

    //old
    if (validateOldPasswd(oldPasswdState)) {
      if (pwFieldFocus == ChangePWFocus.oldpw) {
        oldPassFucus.requestFocus();
      }
    } else {
      if (pwFieldFocus == ChangePWFocus.nextFocus)
      { 
        pwFieldFocus = ChangePWFocus.newpw;
      }
    }
    //new
    if (pwFieldFocus == ChangePWFocus.newpw) {
      // print('checked focus: ${newPasswdState.textFieldError} ${oldNewPasswdState.textFieldError} ${oldPasswdState.textFieldError}');
      if (validateNewPasswd(newPasswdState, oldNewPasswdState, oldPasswdState)) 
      {
        newPassFucus.requestFocus();
      } 
      else 
      {
        pwFieldFocus = ChangePWFocus.retypepw;
        // print('checked focus go toretype : $pwFieldFocus');
      }
    }
    
    //retype
    if (validateRetypePasswd(newPasswdState,oldNewPasswdState, retypePasswdState)) {
      // print('checked focus go toretype : $pwFieldFocus');
      if (pwFieldFocus == ChangePWFocus.retypepw) {
        retypePassFucus.requestFocus();
      }
    }
  }

}
