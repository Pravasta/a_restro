class ConnectionFailure {
  final String message;

  ConnectionFailure({this.message = 'Failed to connect to the network'});
}

class ServerFailure {
  final String message;
  ServerFailure({this.message = 'Server Failure'});
}
