import 'dart:io';
import 'package:services_flutter/view/widget/customButton.dart';
import 'package:services_flutter/view/widget/customDrawer.dart';
import 'package:services_flutter/view/widget/inputField/textFieldWithHeader.dart';
import 'package:services_flutter/view_model/bloc/debouncer/debouncer.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldEvent.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/TextFieldState.dart';
import 'package:services_flutter/view_model/bloc/textField_bloc/textField_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextFieldBloc? _nameTextFieldBloc;
  TextFieldBloc? _emailTextFieldBloc;
  TextFieldBloc? _phoneTextFieldBloc;

  String firstName   = 'Sophaldevid';
  String lastName    = 'KONG';
  String email       = 'uxer@cotafer.com';
  String phoneNumber = '+855 14 789 123';

  var imageFile;
  // Future pickImageFromGallery() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) return;

  //     final imageTempory = File(image.path);
  //     setState(() => this.imageFile = imageTempory);
  //   } on PlatformException catch (e) {
  //     print('error $e');
  //   }
  // }

  @override
  void initState() {
    this._nameTextFieldBloc  = TextFieldBloc();
    this._emailTextFieldBloc = TextFieldBloc();
    this._phoneTextFieldBloc = TextFieldBloc();

    super.initState();
  }

  @override
  void dispose() {
    _nameTextFieldBloc!.close();
    _emailTextFieldBloc!.close();
    _phoneTextFieldBloc!.close();

    super.dispose();
  }

//if empty color red , changed color green

  
  var _fromKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

  // FocusScopeNode currentFocus = FocusScope.of(context);
    return MultiBlocProvider(
        providers: [
          BlocProvider<TextFieldBloc>(
            create: (BuildContext context) => TextFieldBloc(),
          ),
        ],
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Scaffold(
            drawer: CustomeDrawer(
              selectedMenu: 1,
            ),
            appBar: AppBar(
              centerTitle: true,
              title: Text('Profile'),
            ),
            body: SingleChildScrollView(
                child: BlocBuilder<TextFieldBloc, TextFieldState>(
                    bloc: _nameTextFieldBloc,
                    builder: (context, nameState) {
                      // print('nameState${nameState.textFieldError}');
                      return BlocBuilder<TextFieldBloc, TextFieldState>(
                          bloc: _emailTextFieldBloc,
                          builder: (context, emailState) {
                            // print('emailState${emailState.textFieldError}');
                            return BlocBuilder<TextFieldBloc, TextFieldState>(
                                bloc: _phoneTextFieldBloc,
                                builder: (context, phoneNumberState) {
                                  // print('phoneNumberState${phoneNumberState.textFieldError}');
                                  return Column(
                                    children: [
                                      //Headder and Profile pic
                                      Container(
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children : [
                                            Container(
                                              height: 100,
                                              width : double.infinity,
                                              color : Colors.indigo,
                                            ),
                                            Positioned(
                                              top  : 20,
                                              child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.indigo,
                                                  ),
                                                  child: Container(
                                                    height: 160,
                                                    width: 160,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          Color.fromRGBO(222, 222, 222, 1),
                                                      image: imageFile != null
                                                          ? DecorationImage(
                                                              image: FileImage(imageFile),
                                                              fit: BoxFit.cover,
                                                            )
                                                          : null,
                                                    ),
                                                  )),
                                            ),
                                            SizedBox(height: 200)
                                          ],
                                        ),
                                      ),
                                      //Change profile photo
                                      InkWell(
                                          onTap: () {
                                            // pickImageFromGallery();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10.0),
                                            child  : Text(
                                              'Change Profile Photo',
                                              style: TextStyle(color: Colors.indigo),
                                            ),
                                          )),
                                      //TextField
                                      Form(
                                        key: _fromKey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child  : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // First / Last Name
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: 10),
                                                child: Row(
                                                  children: [
                                                    //First name
                                                    Expanded(
                                                        child: Container(
                                                      padding: EdgeInsets.only(right: 10),
                                                      child: TextfieldWithHeader(
                                                        textColor: checkChangedField(nameState.textFieldError)
                                                            ? Colors.green
                                                            : Colors.black,
                                                        onChanged: (value) {
                                                          _debouncer.run(() {
                                                            firstNameChangeEvent(value);
                                                          });
                                                        },
                                                        validate: checkInvalidField(
                                                            nameState.textFieldError),
                                                        headText: 'First Name',
                                                        valueText: '$firstName',
                                                      ),
                                                    )),
                                      
                                                    //Last name
                                                    Expanded(
                                                        child: Container(
                                                      padding: EdgeInsets.only(left: 10),
                                                      child: TextfieldWithHeader(
                                                        textColor: checkChangedField(nameState.textFieldError)
                                                            ? Colors.green
                                                            : Colors.black,
                                                        onChanged: (value) {
                                                          _debouncer.run(() {
                                                            lastNameChangeEvent(value);
                                                          });
                                                        },
                                                        validate: checkInvalidField(nameState.textFieldError),
                                                        headText: 'Last Name',
                                                        valueText: lastName,
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                      
                                              // Email
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: 10),
                                                child: TextfieldWithHeader(
                                                  validate: (checkEmptyField(
                                                              emailState.textFieldError) ||
                                                          checkInvalidField(
                                                              emailState.textFieldError))
                                                      ? true
                                                      : false,
                                                  textColor: checkChangedField(
                                                          emailState.textFieldError)
                                                      ? Colors.green
                                                      : Colors.black,
                                                  onChanged: (value) {
                                                    //Bloc event
                                                  _debouncer.run(() {
                                                    emailChangeEvent(value);
                                                  });
                                                  },
                                                  headText : 'Email',
                                                  valueText: 'uxer@cotafer.com',
                                                ),
                                              ),
                                      
                                              // Phone number
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: 10),
                                                child  : TextfieldWithHeader(
                                                  textColor: checkChangedField(phoneNumberState.textFieldError)
                                                      ? Colors.green
                                                      : Colors.black,
                                                  onChanged: (value) {
                                                    _debouncer.run(() {
                                                      phoneChangeEvent(value);
                                                    });
                                                  },
                                                   validate: (checkEmptyField(
                                                              phoneNumberState.textFieldError) ||
                                                          checkInvalidField(
                                                              phoneNumberState
                                                              .textFieldError))
                                                      ? true
                                                      : false,
                                                  numberType: true,
                                                  headText  : 'Phone number',
                                                  valueText : '+' + '855 ' + '14 789 123',
                                                ),
                                              ),
                                      
                                              checkInputChange(nameState, emailState,
                                                          phoneNumberState) !=  ''
                                                  ? Text('Error please check your input',
                                                      style: TextStyle(color: Colors.red))
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ),
                                  
                                      //Save Button
                                      checkIfTextFieldChanged(nameState,emailState,phoneNumberState)?
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomButton(
                                            btText : 'Save',
                                            btWidth:
                                                MediaQuery.of(context).size.width * 0.475 -
                                                    10,
                                            btHieght : 50,
                                            onPressed: () {},
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.05,
                                          ),
                                          CustomButton(
                                            btColor    : Color.fromRGBO(222, 222, 222, 1),
                                            btTextColor: Colors.indigo,
                                            btText     : 'Cancel',
                                            btWidth    :
                                                MediaQuery.of(context).size.width * 0.475 -
                                                    10,
                                            btHieght   : 50,
                                            onPressed: (){                                                                                                 
                                                    FocusScope.of(context)
                                                        .requestFocus(new FocusNode());
                                                    _fromKey.currentState!.reset();
                                                    firstNameChangeEvent(firstName);
                                                    lastNameChangeEvent(lastName);
                                                    emailChangeEvent(email);
                                                    phoneChangeEvent(phoneNumber); 
                                                    
                                              // setState(() {
                                                      
                                              // });
                                            },
                                          ),
                                        ],
                                      )
                                    :SizedBox(),
                                    ],
                                  );
                                });
                          });
                    })),
          ),
        ));
  }

  checkEmptyField(TextFieldError error) {
    if (error == TextFieldError.Empty) {
      return true;
    } else {
      return false;
    }
  }

  checkChangedField(TextFieldError error) {
    if (error == TextFieldError.Changed)
      return true;
    else
      return false;
  }

  checkInvalidField(TextFieldError error) {
    if (error == TextFieldError.Invalid) {
      return true;
    } else {
      return false;
    }
  }

  checkInputChange(TextFieldState nameState, emailState, phoneState) {
    if (checkEmptyField(nameState.textFieldError)) return 'Please input username';

    if (checkEmptyField(emailState.textFieldError))
      return 'Please input your Email Address';

    if (checkEmptyField(phoneState.textFieldError)) return 'Please input phone number';
    return '';
  }

  bool checkIfTextFieldChanged(TextFieldState nameState, emailState, phoneState) {
    if (nameState.textFieldError == TextFieldError.Changed ||
        emailState.textFieldError == TextFieldError.Changed ||
        phoneState.textFieldError == TextFieldError.Changed ||
        nameState.textFieldError == TextFieldError.Invalid ||
        emailState.textFieldError == TextFieldError.Invalid ||
        phoneState.textFieldError == TextFieldError.Invalid) {
      return true;
    } else {
      return false;
    }
  }

  final _debouncer = Debouncer(milliseconds: 100);

  firstNameChangeEvent(value) {
    this
        ._nameTextFieldBloc!
        .add(TextFieldOnChangeEvent(previousText: firstName, text: value));
  }

  lastNameChangeEvent(value) {
    this
        ._nameTextFieldBloc!
        .add(TextFieldOnChangeEvent(previousText: lastName, text: value));
  }

  emailChangeEvent(value) {
    this
        ._emailTextFieldBloc!
        .add(TextFieldOnChangeEvent(email: value, text: value, previousText: email));
  }

  phoneChangeEvent(value) {
    this._phoneTextFieldBloc!.add(
        TextFieldOnChangeEvent(previousText: phoneNumber, text: value, number: value));
  }
}
