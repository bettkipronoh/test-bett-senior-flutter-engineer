import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit() : super(ConnectivityInitial());
  Future<void> listenToConnection() async {
    InternetConnection().onStatusChange.listen((InternetStatus status) {
      log("CONNECTION STATUS::$status");
      emit(CurrentConnectivityStatus(status));
    });
  }
}
