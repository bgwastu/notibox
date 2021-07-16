import 'package:get/get.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/inbox/inbox_service.dart';

class InboxSearchController extends GetxController {
  final _notionProvider = Get.put(InboxService());

  RxString searchQuery = ''.obs;
  
  Future<List<Inbox>> getListSuggestion() => _notionProvider.getListSuggestion(searchQuery.value); 

}
