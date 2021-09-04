import 'dart:developer';
import 'package:flutter/material.dart';
import '../components/common_alert_dialog.dart';

class LoadingScreen<T> extends StatelessWidget {

  LoadingScreen({
    required this.future,
    required this.func,
    this.errFunc,
  }) : assert(future != null);

  final Future<T>? future;
  final Widget Function(Object? error)? errFunc;

  final Widget Function(T? res) func;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return func(snapshot.data);
        else if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) return func(snapshot.data);
        if (snapshot.hasError) {
          log('err: ${snapshot.error}', name: 'LoadingPage');
          String errMessage = "Something went wrong";
          if (snapshot.error is String) errMessage = snapshot.error as String;
          return errFunc != null
              ? errFunc!(snapshot.error)
              : Scaffold(
                  body: Center(
                    child: CommonAlertDialog(
                      errMessage,
                      error: true,
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
