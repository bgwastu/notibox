import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notibox/app/inbox/home_inbox/home_controller.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/inbox/search_inbox/inbox_search_controller.dart';
import 'package:notibox/utils/ui_helpers.dart';

class InboxSearchDelegate extends SearchDelegate {
  final List<Inbox> listInbox;
  final controller = Get.put(InboxSearchController());
  final homeController = Get.find<HomeController>();

  InboxSearchDelegate(this.listInbox);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    controller.searchQuery.value = query;

    final filteredList = listInbox.where((inbox) {
      if (inbox.description != null) {
        // check with title
        if (inbox.title.toLowerCase().contains(query.toLowerCase()) ||
            inbox.description!.toLowerCase().contains(query.toLowerCase())) {
          return true;
        }
      }

      // only check title
      return inbox.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (query.isEmpty) {
      return Container();
    }
    return filteredList.isBlank!
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 3 / 1,
                child: SvgPicture.asset('assets/images/no_data.svg'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Inbox Not Found',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(
                width: 200,
                child: Text(
                  '$query is not found in your inbox list',
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ))
        : ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (ctx, i) {
              return _listCardItem(filteredList[i], context, i);
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredList = listInbox
        .where(
            (inbox) => inbox.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (query.isEmpty) {
      return Container();
    }
    controller.searchQuery.value = query.trim();
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (ctx, i) {
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(filteredList[i].title.toLowerCase()),
          onTap: () {
            query = filteredList[i].title.toLowerCase();
            showResults(context);
          },
        );
      },
    );
  }

  Card _listCardItem(Inbox inbox, BuildContext context, int index) {
    return Card(
        child: InkWell(
      onTap: () {
        Navigator.pop(context);
        homeController.viewInbox(inbox, index);
      },
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
            verticalSpaceSmall,
            if (inbox.description != null)
              Text(
                inbox.description!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(height: 1.3),
              )
            else
              Container(),
          ],
        ),
      ),
    ));
  }
}
