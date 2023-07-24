import 'package:flutter/material.dart';
import 'package:meditation_app/helper/date_converter.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';

import '../../../theme/styles.dart';
import '../../common/custom_app_bar.dart';

class NModel {
  final String message;
  final String url;
  final DateTime receviedAt;
  NModel(this.message, this.url, this.receviedAt);
}

class NotificationsScreens extends StatefulWidget {
  const NotificationsScreens({super.key});

  @override
  State<NotificationsScreens> createState() => _NotificationsScreensState();
}

class _NotificationsScreensState extends State<NotificationsScreens> {
  static AppStyle _style = AppStyle();
  bool notification = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    List<NModel> list = [
      NModel(
        'Calm Oases has updated.',
        'https://images.pexels.com/photos/4151865/pexels-photo-4151865.jpeg?auto=compress&cs=tinysrgb&w=1920&h=1280&dpr=1',
        DateTime.now(),
      ),
      NModel(
        'Check Out the new video of Transcendental Meditation.',
        'https://images.pexels.com/photos/6740518/pexels-photo-6740518.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        DateTime.now(),
      ),
      NModel(
        'You have near about to complete your milestone.',
        'https://images.pexels.com/photos/1034940/pexels-photo-1034940.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        DateTime.now(),
      ),
      NModel(
        '15% Discount available on exercise category.',
        'https://images.pexels.com/photos/841128/pexels-photo-841128.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        DateTime.now(),
      ),
      NModel(
        'Inhale peace, exhale gratitude. Find stillness within.',
        'https://images.pexels.com/photos/4553618/pexels-photo-4553618.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        DateTime.now(),
      ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        screenSize: size,
        style: _style,
        title: 'Notification',
      ),
      body: BackgroundImage(
        alignment: Alignment.topCenter,
        child: SafeArea(
          bottom: false,
          child: ListView.separated(
            padding: EdgeInsets.only(
              left: _style.scaleX(20),
              top: _style.scaleX(60),
              bottom: _style.scaleX(30),
            ),
            itemBuilder: (context, index) {
              return NotificationItem(
                message: list[index].message,
                url: list[index].url,
                receviedAt: DateTime.now().subtract(Duration(days: index + 1)),
                appStyle: _style,
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: _style.scaleX(30));
            },
            itemCount: list.length,
          ),
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String message;
  final String url;
  final DateTime receviedAt;
  final AppStyle appStyle;
  const NotificationItem(
      {super.key, required this.message, required this.receviedAt, required this.url, required this.appStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                message,
                style: appStyle.text.font(mulishSemiBold600, sizePx: 12.5),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: appStyle.scaleX(5)),
              Text(
                receviedAt.toStringFormat2,
                style: appStyle.text.font(mulishSemiBold600, sizePx: 9, color: const Color(0xFF717171)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Divider(color: AppColors.primaryColor, endIndent: appStyle.scaleX(10)),
            ],
          ),
        ),
        SizedBox(width: appStyle.scaleX(50)),
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(appStyle.scaleX(50)),
            bottomLeft: Radius.circular(appStyle.scaleX(50)),
          ),
          child: Image.network(
            url,
            width: appStyle.scaleX(52),
            height: appStyle.scaleX(49.5),
            fit: BoxFit.cover,
          ),
        )
      ],
    );
  }
}
