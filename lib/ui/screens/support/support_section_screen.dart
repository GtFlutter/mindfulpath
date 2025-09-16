import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/model/support_ticket_body_model.dart';
import 'package:meditation_app/provider/support_provider.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/support/widget/support_section_ticket_item.dart';

import '../../../data/model/response/response_error.dart';
import '../../../helper/route/route_paths.dart';
import '../../../theme/styles.dart';
import '../../common/custom_app_bar.dart';

class SupportSectionScreen extends ConsumerStatefulWidget {
  const SupportSectionScreen({super.key});

  @override
  ConsumerState<SupportSectionScreen> createState() =>
      _SupportSectionScreenState();
}

class _SupportSectionScreenState extends ConsumerState<SupportSectionScreen> {
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    // ignore: unused_result
    ref.refresh(supportTicketsListProvider.future);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    var supportP = ref.watch(supportProvider);

    AsyncValue<List<SupportTicket>> list =
        ref.watch(supportTicketsListProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        screenSize: size,
        style: _style,
        title: 'Support History',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              child: const Text("Get Help"),

              onPressed: () async {
                context.push(RoutePath.supportScreenPath).then((value) {

                },); // navigate to the support form


              },
            ),
          ),
        ],
      ),
      body: BackgroundImage(
        alignment: Alignment.topCenter,
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(supportTicketsListProvider.future),
            child: list.when(
              skipLoadingOnRefresh: false,
              data: (data) {
                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: _style.scaleX(20),
                      vertical: _style.scaleX(25)),
                  itemBuilder: (context, index) {
                    return SupportSectionTicketItem(
                      style: _style,
                      ticket: data[index],
                      onPressed: () async {
                        supportP.name = data[index].name;
                        supportP.email = data[index].email;
                        supportP.descr = data[index].description;
                        context.go(RoutePath.supportScreenPath);
                        // Navigator.pop(context);

                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: _style.scaleX(25));
                  },
                  itemCount: data.length,
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
                                ref.refresh(supportTicketsListProvider.future);
                              }
                            },
                            child: Text(
                                err.statusCode == 401 ? 'Sign In' : 'Retry'),
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
        ),
      ),
    );
  }
}
