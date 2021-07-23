import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notibox/app/inbox/create_inbox/create_inbox_view.dart';
import 'package:notibox/app/inbox/feedback/feedback_page.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/inbox/search_inbox/inbox_search_delegate.dart';
import 'package:notibox/app/settings/settings_view.dart';
import 'package:notibox/utils/ui_helpers.dart';
import 'package:open_settings/open_settings.dart';
import 'package:shimmer/shimmer.dart';

import 'home_controller.dart';

class HomeView extends StatelessWidget {
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.inbox),
        title: const Text('Notibox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: InboxSearchDelegate(controller.listInbox.value),
              );
            },
          ),
          PopupMenuButton<int>(
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Settings'),
                    ),
                    const PopupMenuItem(value: 2, child: Text('Feedback')),
                  ],
              onSelected: (index) {
                if (index == 1) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SettingsView()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage()));
                }
              },
              icon: const Icon(Icons.more_vert))
        ],
      ),
      floatingActionButton: Obx(() => Visibility(
            visible: controller.isReady(),
            child: OpenContainer(
              openBuilder: (BuildContext context, VoidCallback _) {
                return CreateInboxView();
              },
              onClosed: (inbox) {
                if (inbox != null) {
                  controller.createInbox(inbox as Inbox);
                }
              },
              closedElevation: 6.0,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(fabDimension / 2),
                ),
              ),
              closedColor: Theme.of(context).colorScheme.secondary,
              middleColor: Get.theme.backgroundColor,
              closedBuilder:
                  (BuildContext context, VoidCallback openContainer) {
                return SizedBox(
                  height: fabDimension,
                  width: fabDimension,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                );
              },
            ),
          )),
      body: RefreshIndicator(
        key: controller.indicator,
        onRefresh: controller.getListInbox,
        child: Obx(() {
          if (controller.homeState.value == HomeState.error) {
            return _errorState(controller, context);
          }

          if (controller.homeState.value == HomeState.initial) {
            return _listShimmer();
          }

          return Obx(
            () => Column(
              children: [
                if (controller.homeState.value == HomeState.noInternet)
                  _noInternetBanner(),
                Expanded(
                  child: Obx(() {
                    if (controller.homeState.value == HomeState.empty) {
                      return _emptyState(controller, context);
                    }

                    return _listInbox(controller);
                  }),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _listInbox(HomeController controller) {
    return AnimationLimiter(
      child: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          itemCount: controller.listInbox.value.length,
          itemBuilder: (BuildContext context, int index) {
            final inbox = controller.listInbox.value[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _listItem(inbox, context, index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _listShimmer() {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Shimmer.fromColors(
                  baseColor: Get.isDarkMode
                      ? Colors.grey.shade600
                      : Colors.grey.shade200,
                  highlightColor: Get.isDarkMode
                      ? Colors.grey.shade500
                      : Colors.grey.shade300,
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                    child: Container(
                      height: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _listItem(Inbox inbox, BuildContext context, int index) {
    return Card(
        margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
        child: InkWell(
          onTap: () =>
              inbox.pageId == null ? null : controller.viewInbox(inbox, index),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (inbox.reminder != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          size: 18,
                          color: inbox.reminder!.isBefore(DateTime.now())
                              ? Theme.of(context).errorColor
                              : null,
                        ),
                        horizontalSpaceTiny,
                        Text(
                          DateFormat.yMMMd()
                              .add_jm()
                              .format(inbox.reminder!)
                              .toUpperCase(),
                          style: inbox.reminder!.isBefore(DateTime.now())
                              ? Theme.of(context).textTheme.subtitle2?.copyWith(
                                  color: Theme.of(context).errorColor)
                              : Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  )
                else
                  Container(),
                Text(inbox.title, style: Theme.of(context).textTheme.headline6),
                if (inbox.description != null && !inbox.description.isBlank!)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      inbox.description!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else
                  Container(),
              ],
            ),
          ),
        ));
  }

  Material _noInternetBanner() {
    return Material(
      elevation: 2,
      child: MaterialBanner(
          content: const Text(
            'No internet connection.',
          ),
          leading: const Icon(
            Icons.sync_disabled,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => OpenSettings.openNetworkOperatorSetting(),
              child: Text('Network Settting'.toUpperCase()),
            ),
          ]),
    );
  }

  Widget _errorState(HomeController controller, BuildContext context) {
    return Stack(
      children: [
        ListView(),
        Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: SvgPicture.asset('assets/images/road_trip.svg'),
              ),
              Text(
                'An error occurred',
                style: Theme.of(context).textTheme.headline6,
              ),
              verticalSpaceSmall,
              SizedBox(
                width: 200,
                child: Text(
                  controller.errorMessage.value,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _emptyState(HomeController controller, BuildContext context) {
    return Stack(
      children: [
        ListView(),
        Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: SvgPicture.asset('assets/images/empty_inbox.svg'),
              ),
              Text(
                'Empty Inbox',
                style: Theme.of(context).textTheme.headline6,
              ),
              verticalSpaceSmall,
              SizedBox(
                width: 200,
                child: Text(
                  'Create inbox message, and it will show here.',
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
