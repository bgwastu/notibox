import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.inbox),
        title: Text('Notibox'),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: (){},),
          PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(child: Text('Settings')),
                PopupMenuItem(child: Text('About')),
              ],
              icon: Icon(Icons.more_vert)
            )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Create'.toUpperCase()),
        icon: Icon(Icons.add),
        onPressed: (){},
      ),
      body: Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
