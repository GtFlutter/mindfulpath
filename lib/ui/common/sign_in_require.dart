import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../helper/route/route_paths.dart';
import '../../util/dimensions.dart';

class SignInRequire extends StatelessWidget {
  const SignInRequire({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT,
          vertical: Dimensions.PADDING_SIZE_DEFAULT,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sign in to access your analytics',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
            FilledButton(
              onPressed: () => context.go(RoutePath.signIn),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
