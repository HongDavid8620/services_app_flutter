import 'package:services_flutter/view/widget/customButton.dart';
import 'package:services_flutter/view/widget/inputField/inputTextField.dart';
import 'package:services_flutter/view/widget/showLoadingDialog.dart';
import 'package:services_flutter/view/widget/textErrorMessage.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldEvent.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldState.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/textField_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
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
            body: BlocBuilder<TextFieldBloc, TextFieldState>(
                bloc    : _oldPasswordFieldBloc,
                builder : (context, oldPasswdState) {
                  //BlocBuilder for Newpassword
                  return BlocBuilder<TextFieldBloc, TextFieldState>(
                      bloc    : _newPasswdFieldBloc,
                      builder : (context, newPasswdState) {
                        //BlocBuilder for Retypepassword
                        return BlocBuilder<TextFieldBloc, TextFieldState>(
                            bloc    : _retypePasswdFieldBloc,
                            builder : (context, retypePasswdState) {
                              return BlocBuilder<TextFieldBloc, TextFieldState>(
                                  bloc    : _oldNewPasswdFieldBloc,
                                  builder : (context, oldNewPasswdState) {
                                    //set error message
                                    _errorMessage = passwordErrorMessage(newPasswdState, oldNewPasswdState, oldPasswdState, retypePasswdState);
                                    
                                    //check if all field validated tell bloc listener to navigate
                                    if (newPasswdState.textFieldError == TextFieldError.Validate &&
                                        oldPasswdState.textFieldError == TextFieldError.Validate &&
                                        retypePasswdState.textFieldError == TextFieldError.Validate &&
                                        oldNewPasswdState.textFieldError == TextFieldError.Validate) 
                                        { 
                                          _signInListenerBloc!.add(SubmitEvent(textFieldError: TextFieldError.Validate));
                                        }

                                    return BlocListener<TextFieldBloc, TextFieldState>(
                                        bloc: _signInListenerBloc,
                                        listener: (context, TextFieldState state) {                                          
                                          if (oldNewPasswdState.textFieldError == TextFieldError.Validate) {
                                            checkRetype(_retypePasswdFieldBloc!); //check retype validate after newpasswd field validate
                                          }
                                          if (state.textFieldError == TextFieldError.Validate) {    //navigate when all field validate
                                            Navigator.pop(context);
                                            _signInListenerBloc!.close();
                                          }
                                        },
                                        child: Padding(
                                          padding : const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child   : Form(
                                            key    : _fromKey,
                                            child  : Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                //Error Message
                                                TextErrorMessage(
                                                  newMessage: '$_errorMessage',
                                                ),

                                                //Old paaswd
                                                Padding(
                                                  padding : const EdgeInsets.only(bottom: 25.0),
                                                  child   : InputTextField(
                                                    password  : true,
                                                    validate  : (oldPasswdState.textFieldError == TextFieldError.Invalid) ? true : false,
                                                    onChanged : (value) {
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

                                                //New passwd
                                                Padding(
                                                  padding : const EdgeInsets.only(bottom: 25.0),
                                                  child   : InputTextField(
                                                      password: true,
                                                      validate: (newPasswdState.textFieldError == TextFieldError.InvalidPasswd ||
                                                              oldNewPasswdState.textFieldError == TextFieldError.InvalidOldPasswd)
                                                          ? true
                                                          : false,
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
                                                      textColor: (newPasswdState.textFieldError == TextFieldError.InvalidPasswd ||
                                                              oldNewPasswdState.textFieldError == TextFieldError.InvalidOldPasswd)
                                                          ? Colors.red
                                                          : Colors.black),
                                                ),

                                                //Retype passwd
                                                Padding(
                                                  padding : const EdgeInsets.only(bottom: 25.0),
                                                  child   : InputTextField(
                                                    password: true,
                                                    text    : 'Re-type new password',
                                                    onSaved : (value) {
                                                      setState(() {
                                                        retypeNewPasswd = value;
                                                      });
                                                    },
                                                    onChanged: (value) {
                                                      setState(() {
                                                        retypeNewPasswd = value;
                                                      });
                                                    },
                                                    textColor: _errorMessage != '' &&
                                                            oldNewPasswdState.textFieldError == TextFieldError.Validate &&
                                                            retypePasswdState.textFieldError == TextFieldError.Invalid
                                                        ? Colors.red
                                                        : Colors.black,
                                                    validate: _errorMessage != '' &&
                                                            oldNewPasswdState.textFieldError == TextFieldError.Validate &&
                                                            retypePasswdState.textFieldError == TextFieldError.Invalid
                                                        ? true
                                                        : false,
                                                  ),
                                                ),

                                                //Button save and cancel
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    CustomButton(
                                                      btText    : 'Save',
                                                      btWidth   : MediaQuery.of(context).size.width * 0.475 - 10,
                                                      btHieght  : 50,
                                                      onPressed : () {
                                                        _fromKey.currentState!.save();
                                                        setState(() {
                                                        });
                                                        onSave(
                                                            oldPasswdState    : oldPasswdState,
                                                            newPasswdState    : newPasswdState,
                                                            oldNewPasswdState : oldNewPasswdState,
                                                            retypePasswdState : retypePasswdState);
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width * 0.05,
                                                    ),
                                                    CustomButton(
                                                      btColor     : Color.fromRGBO(222, 222, 222, 1),
                                                      btTextColor : Colors.indigo,
                                                      btText      : 'Cancel',
                                                      btWidth     : MediaQuery.of(context).size.width * 0.475 - 10,
                                                      btHieght    : 50,
                                                      onPressed   : () {
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
                                        ));
                                  });
                            });
                      });
                })));
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
  
  onSave({TextFieldState? oldPasswdState, TextFieldState? newPasswdState, TextFieldState? oldNewPasswdState, TextFieldState? retypePasswdState}) async {
      FocusScope.of(context).requestFocus(new FocusNode());
      await loading();
      checkNewPasswdOldPasswd(_oldNewPasswdFieldBloc!); //check old and new password
      passwdCheckEmptyEvent(oldPasswd, _oldPasswordFieldBloc); //check empty
      checkRetype(_newPasswdFieldBloc!); //check validate new password
      checkRetype(_retypePasswdFieldBloc!); //check retype password and new password
    }
    
  checkAllValidate({TextFieldState? newPasswdState, TextFieldState? oldPasswdState, TextFieldState? retypePasswdState}) {
    if (newPasswdState!.textFieldError == TextFieldError.InvalidPasswd || newPasswdState.textFieldError == TextFieldError.InvalidOldPasswd) {
      return true;
    }
    if (retypePasswdState!.textFieldError == TextFieldError.Invalid) {
      return true;
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

  loading() async {
    ShowLoadingDialog(context).showLoaderDialog();
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.pop(context);
  }
}
