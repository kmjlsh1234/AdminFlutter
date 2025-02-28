import 'package:flutter/material.dart';

class FutureBuilderFactory {

  static Widget createFutureBuilder<T>({required Future<T> future, required Widget Function(BuildContext context, T data) onSuccess}) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No Data Available'));
        }
        return onSuccess(context, snapshot.data!);
      },
    );
  }
}