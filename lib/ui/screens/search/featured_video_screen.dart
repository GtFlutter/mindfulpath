import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';

import '../../../provider/featured_videos_provider.dart';
import '../../../util/assets.dart';
import '../../common/feature_video_list.dart';
import '../discover/widget/discover_header.dart';

class FeaturedVideoScreen extends StatefulWidget {
  const FeaturedVideoScreen({super.key});

  @override
  State<FeaturedVideoScreen> createState() => _FeaturedVideoScreenState();
}

class _FeaturedVideoScreenState extends State<FeaturedVideoScreen> {
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundImage(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: _style.scaleX(15), vertical: _style.scaleX(2)),
                margin: EdgeInsets.symmetric(vertical: _style.scaleX(10), horizontal: _style.scaleX(20)),
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: const Color(0xFF2D251F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_style.scaleX(22.5))),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      SvgPaths.search,
                      height: _style.scale * 20,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    SizedBox(width: _style.scaleX(14)),
                    Flexible(
                      child: TextField(
                        readOnly: true,
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.text,
                        onTap: () => context.replace(RoutePath.search),
                        style: _style.text.font(mulishMedium500, sizePx: 11, color: Colors.white, spacingPc: 10),
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Hinted search text',
                          hintStyle:
                              _style.text.font(mulishMedium500, sizePx: 14, color: Colors.white.withOpacity(0.5)),
                          contentPadding: EdgeInsets.only(bottom: _style.scaleX(16)),
                          constraints: BoxConstraints(maxHeight: _style.scaleX(40)),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final provider = ref.watch(featuredVideosProvider);
                    if (provider.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.data == null || provider.data!.list == null) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Unable to fetch Featured Videos!'),
                        ),
                      );
                    }
                    if (provider.data!.list!.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    // List<FeaturedVideoResponse> firstThreeFeature = provider.data!.list!
                    //     .sublist(0, provider.data!.list!.length <= 3 ? provider.data!.list!.length : 3);

                    return Column(
                      children: [
                        DiscoverHeader(title: 'Featured', style: _style),
                        Expanded(
                          child: FeatureVideoList.vertical(
                            key: const ValueKey<String>('fss-vl-1'),
                            list:provider.data!.list!,
                            style: _style,
                            physics: const BouncingScrollPhysics(),
                          ),
                        ),
                      ],
                    );
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
