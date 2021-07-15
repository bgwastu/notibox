import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/data/model/inbox_model.dart';
import 'package:notibox/app/modules/home/views/inbox_search_delegate.dart';
import 'package:notibox/app/routes/app_pages.dart';
import 'package:open_settings/open_settings.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.inbox),
        title: Text('Notibox'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
showSearch(context: context, delegate: InboxSearchDelegate(controller.listInbox.value));
            },
          ),
          PopupMenuButton<int>(
              itemBuilder: (context) => [
                    PopupMenuItem(child: Text('Settings'), value: 1,),
                    PopupMenuItem(child: Text('Feedback'), value: 2),
                  ],
              onSelected: (index){
                print(index);
                if(index == 1){
                  Get.toNamed(Routes.SETTINGS);
                }
              },
              icon: Icon(Icons.more_vert))
        ],
      ),
      floatingActionButton: Obx(() => Visibility(
            visible: !controller.init.value &&
                !controller.isError() &&
                !controller.isOffline.value,
            child: FloatingActionButton.extended(
              label: Text('Create'.toUpperCase()),
              icon: Icon(Icons.add),
              onPressed: controller.createInbox,
            ),
          )),
      body: Obx(() => RefreshIndicator(
            key: controller.indicator,
            onRefresh: controller.getListInbox,
            child: controller.init.value
                ? Container()
                : controller.isError()
                    ? _errorState(controller, context)
                    : controller.isEmpty()
                        ? _emptyState(controller, context)
                        : Column(
                            children: [
                              controller.isOffline.value
                                  ? _noInternetBanner()
                                  : Container(),
                              Expanded(
                                child: _listInbox(controller),
                              ),
                            ],
                          ),
          )),
    );
  }

  ListView _listInbox(HomeController controller) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: controller.listInbox.value.length,
      padding: EdgeInsets.only(top: 8),
      itemBuilder: (BuildContext context, int index) {
        final inbox = controller.listInbox.value[index];

        return _listItem(inbox, context);
      },
    );
  }

  Card _listItem(Inbox inbox, BuildContext context) {
    return Card(
        child: InkWell(
      onTap: () => controller.viewInbox(inbox),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            inbox.reminder != null
                ? Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.notifications, size: 18, color: inbox.reminder!.isBefore(DateTime.now()) ? Theme.of(context).errorColor : null,),
                        horizontalSpaceTiny,
                        Text(
                          DateFormat.yMMMd()
                              .add_jm()
                              .format(inbox.reminder!)
                              .toUpperCase(),
                          style: inbox.reminder!.isBefore(DateTime.now()) ? Theme.of(context).textTheme.subtitle2?.copyWith(color: Theme.of(context).errorColor) : Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  )
                : Container(),
            Text(inbox.title, style: Theme.of(context).textTheme.headline6),
            verticalSpaceSmall,
            inbox.description != null
                ? Text(
                    inbox.description!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(height: 1.3),
                  )
                : Container(),
          ],
        ),
      ),
    ));
  }

  Material _noInternetBanner() {
    return Material(
      elevation: 2,
      child: MaterialBanner(
          content: Text(
            'No internet connection.',
          ),
          leading: Icon(
            Icons.sync_disabled,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Network Settting'.toUpperCase()),
              onPressed: () => OpenSettings.openNetworkOperatorSetting(),
            ),
          ]),
    );
  }

  Widget _errorState(HomeController controller, BuildContext context) {
    return Stack(
      children: [
        ListView(),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                child: SvgPicture.asset('assets/images/road_trip.svg'),
              ),
              Text(
                'An error occurred',
                style: Theme.of(context).textTheme.headline6,
              ),
              verticalSpaceSmall,
              Container(
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
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 150,
                child: SvgPicture.asset('assets/images/empty_inbox.svg'),
              ),
              Text(
                'Empty Inbox',
                style: Theme.of(context).textTheme.headline6,
              ),
              verticalSpaceSmall,
              Container(
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
