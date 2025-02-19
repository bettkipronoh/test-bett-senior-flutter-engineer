part of 'connectivity_cubit.dart';

@immutable
sealed class ConnectivityState {}

final class ConnectivityInitial extends ConnectivityState {}

final class CurrentConnectivityStatus extends ConnectivityState {
  final InternetStatus status;
  CurrentConnectivityStatus(this.status);
}
