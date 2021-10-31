import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:services_flutter/view_model/bloc/network/network_event.dart';
import 'package:services_flutter/view_model/bloc/network/network_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(NetworkState(ConnectionStatus.ConnectionSuccess));

  late StreamSubscription _subscription;

  @override
  Stream<NetworkState> mapEventToState(NetworkEvent event) async* {
    if (event is ListenConnection) {
      _subscription = Connectivity().onConnectivityChanged.listen((status) {
        add(ConnectionChanged(
            (status == ConnectivityResult.none) 
            ? NetworkState(ConnectionStatus.ConnectionFailure) 
            : NetworkState(ConnectionStatus.ConnectionSuccess)));
      });
    }
    if (event is ConnectionChanged) yield event.connection;
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
