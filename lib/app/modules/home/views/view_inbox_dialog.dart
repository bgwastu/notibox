import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/data/model/inbox_model.dart';

class ViewInboxDialog extends AlertDialog {
  final Inbox inbox;

  ViewInboxDialog(this.inbox);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: AlertDialog(
        insetPadding: EdgeInsets.all(8.0),
            contentPadding: EdgeInsets.fromLTRB(24,20,24,0),
        title: inbox.reminder != null ? Text(
          DateFormat('EEE, dd MMM y').format(inbox.reminder!).toUpperCase(),
          style: Theme.of(context).textTheme.subtitle2,
        ) : null,
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(inbox.title, style: Theme.of(context).textTheme.headline6),
              inbox.description != null
                  ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                        inbox.description!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(height: 1.3),
                      ),
                  )
                  : Container(),
              inbox.label != null
                  ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Chip(
                        label: Text(inbox.label!.name),
                backgroundColor: inbox.label!.color,
                      ),
                  )
                  : Container(),
            ],
          )),
        ),
        actions: [
          TextButton(onPressed: (){}, child: Text('Edit'.toUpperCase())),
          TextButton(onPressed: (){}, child: Text('Delete'.toUpperCase()))
        ],
      ),
    );
  }
}
