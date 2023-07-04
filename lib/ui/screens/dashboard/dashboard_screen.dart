import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/main.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/dashboard/widget/dashboard_card.dart';
import 'package:meditation_app/ui/screens/dashboard/widget/dashboard_header.dart';
import 'package:meditation_app/ui/screens/dashboard/widget/featured_card.dart';
import 'package:meditation_app/util/assets.dart';

List<DBTempModel> list = [
  DBTempModel(
    'Mindful',
    'Moments',
    'https://images.pexels.com/photos/4151865/pexels-photo-4151865.jpeg?auto=compress&cs=tinysrgb&w=1920&h=1280&dpr=1',
    'Meditation',
  ),
  DBTempModel(
    'Ketogenic',
    'Diet',
    'https://images.pexels.com/photos/6740518/pexels-photo-6740518.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'Diet',
  ),
  DBTempModel(
    'Therapeutic ',
    'Nutrition',
    'https://images.pexels.com/photos/1034940/pexels-photo-1034940.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'Nutrition',
  ),
  DBTempModel(
    'Flexibility',
    'Training',
    'https://images.pexels.com/photos/841128/pexels-photo-841128.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'Exercise',
  ),
  DBTempModel(
    'Lifestyle',
    'Changes',
    'https://images.pexels.com/photos/4553618/pexels-photo-4553618.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'Cancer prevention',
  ),
];

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('Rebulding Bottom Nav');
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: $style.scale * 60,
        leading: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            SvgPaths.profile,
            width: $style.scale * 20,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: $style.scale * 9),
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                SvgPaths.search,
                width: $style.scale * 20,
                fit: BoxFit.contain,
              ),
              iconSize: $style.scale * 20,
            ),
          ),
        ],
        toolbarHeight: kToolbarHeight * $style.scale,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight($style.scale * 30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: $style.scale * 20, right: $style.scale * 22, bottom: $style.scale * 10),
              child: Text(
                'Good morning',
                style: $style.text.font(mulishLight300, sizePx: 20, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
      body: BackgroundImage(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: $style.scale * 20, top: $style.scale * 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: $style.scale * 22),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return DashboardCard(model: list[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: $style.scale * 25);
                  },
                ),
              ),
              // const DashboardHeader(title: 'Featured'),
              // SizedBox(
              //   height: 120 * $style.scale,
              //   child: ListView.separated(
              //     scrollDirection: Axis.horizontal,
              //     padding: EdgeInsets.symmetric(horizontal: $style.scale * 22),
              //     itemCount: list.length,
              //     itemBuilder: (context, index) {
              //       // return DashboardCard(model: list[index]);
              //       return const FeaturedCard();
              //     },
              //     separatorBuilder: (BuildContext context, int index) {
              //       return SizedBox(width: $style.scale * 18);
              //     },
              //   ),
              // ),
              const DashboardHeader(title: 'Recently played'),
              SizedBox(
                height: 125 * $style.scale,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: $style.scale * 22),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    // return DashboardCard(model: list[index]);
                    return const FeaturedCard();
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: $style.scale * 18);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
