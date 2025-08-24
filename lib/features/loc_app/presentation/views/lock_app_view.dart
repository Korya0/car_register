// lock_app_view.dart
import 'package:car_register_app/core/widgets/common/text_app.dart';
import 'package:flutter/material.dart';

class LockAppView extends StatelessWidget {
  const LockAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: TextApp(text: "App Locked", fontSize: 50)),
    );
  }
}
