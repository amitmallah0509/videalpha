import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NoConnectionView extends StatelessWidget {
  final Widget widget;

  NoConnectionView({Key? key, required this.widget}) : super(key: key) {
    _connectivity.initialise();
  }

  final MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _connectivity.connectedStream,
      builder: (context, snapshot) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: widget,
              ),
              if (snapshot.hasData && snapshot.data == false)
                Container(
                  color: Colors.black,
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'No Internet Connection',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get connectedStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('www.google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add(isOnline && result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi);
  }

  void disposeStream() => _controller.close();
}
