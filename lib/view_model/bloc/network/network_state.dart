enum ConnectionStatus { ConnectionInitial , ConnectionSuccess , ConnectionFailure }

class NetworkState {
  final ConnectionStatus connectionState;
  NetworkState(this.connectionState);
}

