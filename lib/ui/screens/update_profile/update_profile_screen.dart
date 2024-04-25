import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/provider/user_provider.dart';
import 'package:meditation_app/ui/common/background_image.dart';

import '../../../data/model/response/response_error.dart';
import '../../../data/model/response/user_response.dart';
import '../../../theme/styles.dart';
import '../../common/custom_app_bar.dart';
import 'widget/update_profile_form.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final OnNextController _controller = OnNextController();
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    // ignore: unused_result
    ref.refresh(getUserProfileProvider.future);
    log("dnfkjdsnfkdfnklds====${ref.read(authProvider).socialUserData?.socialId}");
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    AsyncValue<UserResponse> user = ref.watch(getUserProfileProvider);

    var userP = ref.watch(userProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      // resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: CustomAppBar(
        screenSize: size,
        style: _style,
        title: 'Edit Profile',
        onDonePressed: user.isLoading ||
                !user.hasValue ||
                user.isRefreshing ||
                user.isReloading ||
                user.hasError ||
                userP.isLoading
            ? null
            : () {
                if (_controller.onNext != null) {
                  _controller.onNext!();
                }
              },
      ),
      body: BackgroundImage(
        alignment: Alignment.topCenter,
        child: user.when(
          skipLoadingOnRefresh: false,
          data: (user) {
            return UpdateProfileForm(
              user: user,
              onNextController: _controller,
            );
          },
          error: (err, stackTrace) {
            if (err is ResponseError) {
              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(_style.scaleX(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        err.error,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () {
                          if (err.statusCode == 401) {
                            context.go(RoutePath.signIn);
                          } else {
                            // ignore: unused_result
                            ref.refresh(getUserProfileProvider.future);
                          }
                        },
                        child: Text(err.statusCode == 401 ? 'Sign In' : 'Retry'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('Unknown Error'));
            }
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
