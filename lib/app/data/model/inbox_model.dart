import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Inbox extends Equatable{
  String? pageId;
  final String title;
  final String? description;
  final DateTime? reminder;
  final Select? label;

  Inbox({
    this.pageId,
    required this.title,
    required this.description,
    required this.reminder,
    required this.label,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['Title'] = {
      'title': [
        {
          'text': {'content': title}
        }
      ]
    };

    map['Description'] = description != null
        ? {
            'rich_text': [
              {
                'text': {'content': description}
              }
            ]
          }
        : '';

    if (reminder != null) {
      map['Reminder'] = {
        'date': {'start': reminder!.toUtc().toIso8601String()}
      };
    } else {
      map['Reminder'] = {'date': null};
    }

    if (label != null) {
      map['Label'] = {'select': label!.toMap()};
    }

    return map;
  }

  factory Inbox.fromMap(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    final listTitle = (properties['Title']['title'] ?? []) as List;
    final description = properties['Description']?['rich_text'] as List;
    final label = properties['Label']?['select'] != null
        ? Select.fromMap(properties['Label']?['select'])
        : null;

    return Inbox(
      pageId: map['id'],
      title: listTitle.isNotEmpty ? listTitle[0]['plain_text'] : 'Untitled',
      reminder:
          DateTime.tryParse(properties['Reminder']?['date']?['start'] ?? '')
                  ?.toLocal() ??
              null,
      label: label,
      description: description.isNotEmpty ? description[0]['plain_text'] : null,
    );
  }

  @override
  List<Object?> get props => [pageId, title, description, reminder];

  @override
  bool? get stringify => true;
}

class Select {
  final String? id;
  final String name;
  final Color? color;

  Select({this.id, required this.name, this.color});

  factory Select.fromMap(Map<String, dynamic> map) {
    late Color color;
    switch (map['color']) {
      case 'default':
        color = Color(0xFFE6E6E4);
        break;
      case 'gray':
        color = Color(0xFFD7D7D5);
        break;
      case 'brown':
        color = Color(0xFFE8D5CC);
        break;
      case 'orange':
        color = Color(0xFFFDDFCC);
        break;
      case 'yellow':
        color = Color(0xFFFBEECC);
        break;
      case 'green':
        color = Color(0xFFCCE7E1);
        break;
      case 'blue':
        color = Color(0xFFCCE4F9);
        break;
      case 'purple':
        color = Color(0xFFE1D3F8);
        break;
      case 'pink':
        color = Color(0xFFF8CCE6);
        break;
      case 'red':
        color = Color(0xFFFFCCD1);
        break;
      default:
        color = Color(0xFFE6E6E4);
        break;
    }
    return Select(id: map['id'], name: map['name'], color: color);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
