import 'package:cotafer_server_status/view/screen/signIn/signIn.dart';
import 'package:cotafer_server_status/view/widget/loadingPage.dart';
import 'package:cotafer_server_status/view_model/bloc/network/network_bloc.dart';
import 'package:cotafer_server_status/view_model/bloc/network/network_state.dart';
import 'package:cotafer_server_status/view_model/service/applicationInstall/applicationInstallService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInWrapper extends StatefulWidget {
  const SignInWrapper({
    Key? key,
  }) : super(key: key);

  @override
  _SignInWrapperState createState() => _SignInWrapperState();
}

class _SignInWrapperState extends State<SignInWrapper> {
  Future? _appInstall;

  @override
  void initState() {
    _appInstall = InstallService.getAuthorizeToken();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkBloc, NetworkState>(builder: (context, state) {
      if (state.connectionState == ConnectionStatus.ConnectionSuccess)
        return FutureBuilder(
            future: _appInstall,
            builder: (context, snapshot) {
              // print('log: ${snapshot.data}');
              if (snapshot.data != null && snapshot.data != 'error') {
                return SignInPage();
              } else if (snapshot.data == 'error') {
                return Scaffold(body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Application installation error'),
                    Text('Please try to relunch this app again'),
                  ],
                )));
              } else {
                return LoadingPage();
              }
            });
      else
        return Scaffold(
          body: Center(
            child: Text('No internet connection'),
          ),
        );
    });
  }
}
