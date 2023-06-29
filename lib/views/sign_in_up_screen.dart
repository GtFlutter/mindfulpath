import 'package:flutter/material.dart';
import 'package:meditation_app/views/base/background_image.dart';

class SignInUpScreen extends StatelessWidget {
  const SignInUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Sign in or up'),
      ),
      body: const BackgroundImage(
        alignment: AlignmentDirectional.center,
      ),
    );
  }
}
