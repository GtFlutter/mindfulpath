import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/notifications/notificationlist_provider.dart';

import '../../../theme/styles.dart';
import '../../common/custom_app_bar.dart';


class NotificationsScreens extends ConsumerStatefulWidget {
  const NotificationsScreens({super.key});

  @override
  ConsumerState<NotificationsScreens> createState() =>
      _NotificationsScreensState();
}

class _NotificationsScreensState extends ConsumerState<NotificationsScreens> {
  static AppStyle _style = AppStyle();
  bool notification = false;

  @override
  void initState() {
    final notificationListP = ref.read(notificationListProvider);
    Future.delayed(
      Duration.zero,
      () {
        notificationListP.getNotificationList(showProgress: true);
        notificationListP.getReadeNotification();
      },
    );
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    var notiList = ref.watch(notificationListProvider);


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
          child: notiList.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : notiList.notificationListResponse == null ||
                      notiList.notificationListResponse!.data!.notificationData!
                          .isEmpty
                  ? const Center(child: Text('No Notification Found'))
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                        left: _style.scaleX(20),
                        top: _style.scaleX(60),
                        bottom: _style.scaleX(30),
                      ),
                      itemCount: notiList.notificationListResponse?.data
                              ?.notificationData?.length ??0,
                      itemBuilder: (context, index) {
                        print('---------index---->${index}');

                        final model = notiList.notificationListResponse?.data
                            ?.notificationData?[index];

                        String utcTime = model?.createdAt??"";
                        DateTime dateTime = DateTime.parse(utcTime);
                        String formattedDateTime = DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);


                        print('------------->${formattedDateTime ?? ""}');
                        return NotificationItem(
                          message: model?.message ?? "",
                          url: model?.image ?? "",
                          receviedAt: formattedDateTime,
                          appStyle: _style,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: _style.scaleX(30));
                      },
                    ),
        ),
      ),
    );
  }

}

class NotificationItem extends StatelessWidget {
  final String message;
  final String url;
  final String receviedAt;
  final AppStyle appStyle;

  const NotificationItem(
      {super.key,
      required this.message,
      required this.receviedAt,
      required this.url,
      required this.appStyle});

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
                receviedAt,
                style: appStyle.text.font(mulishSemiBold600,
                    sizePx: 9, color: const Color(0xFF717171)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Divider(
                  color: AppColors.primaryColor,
                  endIndent: appStyle.scaleX(10)),
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
