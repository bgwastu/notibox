import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/data/model/inbox_model.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black38));
    final controller = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.inbox),
        title: Text('Notibox'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton<int>(
              itemBuilder: (context) => [
                    PopupMenuItem(child: Text('Settings')),
                    PopupMenuItem(child: Text('About')),
                  ],
              icon: Icon(Icons.more_vert))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Create'.toUpperCase()),
        icon: Icon(Icons.add),
        onPressed: () {},
      ),
      body: Obx(() => RefreshIndicator(
        key: controller.indicator,
              onRefresh: controller.getListInbox,
              child: controller.listInbox.value.isEmpty ? Stack(
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
              ) : ListView.builder(
                itemCount: controller.listInbox.value.length,
                itemBuilder: (BuildContext context, int index) {
                  final inbox = controller.listInbox.value[index];

                  return Text(inbox.title);
                },
              ),
            )),
    );
  }
}
