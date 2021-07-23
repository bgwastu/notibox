import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/inbox/view_inbox/view_inbox_controller.dart';
import 'package:notibox/utils/ui_helpers.dart';
import 'package:notibox/utils/utils.dart';

class ViewInboxPage extends StatelessWidget {
  final Inbox inbox;

  const ViewInboxPage(this.inbox);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewInboxController());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => controller.updateInbox(inbox)),
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showModal(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text('This inbox will be deleted.'),
                        actions: [
                          TextButton(
                              onPressed: () => Get.back(),
                              child: Text('Cancel'.toUpperCase())),
                          TextButton(
                              onPressed: () => controller.deleteInbox(inbox),
                              child: Text('Delete'.toUpperCase())),
                        ],
                      );
                    });
              })
        ],
      ),
      body: Padding(
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
                          ? Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.copyWith(color: Theme.of(context).errorColor)
                          : Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
              )
            else
              Container(),
            Text(inbox.title, style: Theme.of(context).textTheme.headline6),
            if (inbox.description?.trim().isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  inbox.description!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(height: 1.3),
                ),
              )
            else
              Container(),
            if (inbox.label != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Chip(
                  label: Text(inbox.label!.name,
                      style: Get.isDarkMode
                          ? Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(color: Colors.black)
                          : null),
                  backgroundColor: Get.isDarkMode
                      ? darken(inbox.label!.color!)
                      : inbox.label!.color,
                ),
              )
            else
              Container(),
          ],
        ),
      ),
    );
  }
}
