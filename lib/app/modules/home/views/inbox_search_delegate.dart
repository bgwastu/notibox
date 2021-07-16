import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/data/model/inbox_model.dart';
import 'package:notibox/app/modules/home/controllers/home_controller.dart';
import 'package:notibox/app/modules/home/controllers/inbox_search_controller.dart';

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
    final filteredList = listInbox
        .where(
            (inbox) => inbox.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (query.isEmpty) {
      return Container();
    }
    return filteredList.isBlank! ? Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search_off, size: 42,),
        verticalSpaceSmall,
        Text('Inbox not found', style: Theme.of(context).textTheme.subtitle1,),
      ],
    )) :  ListView.builder(
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
        Get.back();
        homeController.viewInbox(inbox, index);
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (inbox.reminder != null) Padding(
                    padding: const EdgeInsets.only(bottom: 8),
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
                  ) else Container(),
            Text(inbox.title, style: Theme.of(context).textTheme.headline6),
            verticalSpaceSmall,
            if (inbox.description != null) Text(
                    inbox.description!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(height: 1.3),
                  ) else Container(),
          ],
        ),
      ),
    ));
  }
}
