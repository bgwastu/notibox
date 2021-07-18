const getListDatabaseResponse = {
  "object": "list",
  "results": [
    {
      "object": "database",
      "id": "ab5ebcd7-4fb7-489c-9550-651baa0b34a2",
      "created_time": "2021-07-16T16:06:00.000Z",
      "last_edited_time": "2021-07-16T19:23:00.000Z",
      "title": [
        {
          "type": "text",
          "text": {"content": "Demo Notibox", "link": null},
          "annotations": {
            "bold": false,
            "italic": false,
            "strikethrough": false,
            "underline": false,
            "code": false,
            "color": "default"
          },
          "plain_text": "Demo Notibox",
          "href": null
        }
      ],
      "properties": {
        "Created": {"id": "IPLt", "type": "created_time", "created_time": {}},
        "Label": {
          "id": "Rgke",
          "type": "select",
          "select": {
            "options": [
              {
                "id": "fe8f2ee8-8227-43ac-b4a4-edd3e2400c51",
                "name": "Personal",
                "color": "purple"
              },
              {
                "id": "ff65eba0-7fd0-49b7-9643-434717d4d053",
                "name": "Work",
                "color": "yellow"
              },
              {
                "id": "db8bfb74-386e-4c8e-904d-2fb2291e70af",
                "name": "Misc",
                "color": "red"
              },
              {
                "id": "ed2fe2f7-8cb0-4c65-ab4d-814acf5229ee",
                "name": "Cool",
                "color": "brown"
              }
            ]
          }
        },
        "Description": {"id": "aK}g", "type": "rich_text", "rich_text": {}},
        "Reminder": {"id": "qbJg", "type": "date", "date": {}},
        "Title": {"id": "title", "type": "title", "title": {}}
      },
      "parent": {
        "type": "page_id",
        "page_id": "9c3bb0a9-fbce-41f9-9493-7546710137fc"
      }
    }
  ],
  "next_cursor": null,
  "has_more": false
};

const getDatabaseResponse = {
  "object": "database",
  "id": "ab5ebcd7-4fb7-489c-9550-651baa0b34a2",
  "created_time": "2021-07-16T16:06:00.000Z",
  "last_edited_time": "2021-07-16T19:23:00.000Z",
  "title": [
    {
      "type": "text",
      "text": {"content": "Demo Notibox", "link": null},
      "annotations": {
        "bold": false,
        "italic": false,
        "strikethrough": false,
        "underline": false,
        "code": false,
        "color": "default"
      },
      "plain_text": "Demo Notibox",
      "href": null
    }
  ],
  "properties": {
    "Created": {"id": "IPLt", "type": "created_time", "created_time": {}},
    "Label": {
      "id": "Rgke",
      "type": "select",
      "select": {
        "options": [
          {
            "id": "fe8f2ee8-8227-43ac-b4a4-edd3e2400c51",
            "name": "Personal",
            "color": "purple"
          },
          {
            "id": "ff65eba0-7fd0-49b7-9643-434717d4d053",
            "name": "Work",
            "color": "yellow"
          },
          {
            "id": "db8bfb74-386e-4c8e-904d-2fb2291e70af",
            "name": "Misc",
            "color": "red"
          },
          {
            "id": "ed2fe2f7-8cb0-4c65-ab4d-814acf5229ee",
            "name": "Cool",
            "color": "brown"
          }
        ]
      }
    },
    "Description": {"id": "aK}g", "type": "rich_text", "rich_text": {}},
    "Reminder": {"id": "qbJg", "type": "date", "date": {}},
    "Title": {"id": "title", "type": "title", "title": {}}
  },
  "parent": {
    "type": "page_id",
    "page_id": "9c3bb0a9-fbce-41f9-9493-7546710137fc"
  }
};

const checkAPIResponse = {
  "object": "list",
  "results": [
    {
      "object": "user",
      "id": "test_id",
      "name": "Test name",
      "avatar_url": "",
      "type": "person",
      "person": {"email": ""}
    },
    {
      "object": "user",
      "id": "test",
      "name": "Notibox",
      "avatar_url": null,
      "type": "bot",
      "bot": {}
    },
  ],
  "next_cursor": null,
  "has_more": false
};

const getListInboxResponse = {
  "object": "list",
  "results": [
    {
      "object": "page",
      "id": "3a69a00a-b816-460c-804a-6a8fb0cf7857",
      "created_time": "2021-07-18T05:23:00.000Z",
      "last_edited_time": "2021-07-18T05:23:00.000Z",
      "parent": {
        "type": "database_id",
        "database_id": "ab5ebcd7-4fb7-489c-9550-651baa0b34a2"
      },
      "archived": false,
      "properties": {
        "Created": {
          "id": "IPLt",
          "type": "created_time",
          "created_time": "2021-07-18T05:23:00.000Z"
        },
        "Label": {
          "id": "Rgke",
          "type": "select",
          "select": {
            "id": "fe8f2ee8-8227-43ac-b4a4-edd3e2400c51",
            "name": "Personal",
            "color": "purple"
          }
        },
        "Description": {
          "id": "aK}g",
          "type": "rich_text",
          "rich_text": [
            {
              "type": "text",
              "text": {"content": "do not delete", "link": null},
              "annotations": {
                "bold": false,
                "italic": false,
                "strikethrough": false,
                "underline": false,
                "code": false,
                "color": "default"
              },
              "plain_text": "do not delete",
              "href": null
            }
          ]
        },
        "Reminder": {
          "id": "qbJg",
          "type": "date",
          "date": {"start": "2021-07-18T05:23:00.000+00:00", "end": null}
        },
        "Title": {
          "id": "title",
          "type": "title",
          "title": [
            {
              "type": "text",
              "text": {"content": "Test Database", "link": null},
              "annotations": {
                "bold": false,
                "italic": false,
                "strikethrough": false,
                "underline": false,
                "code": false,
                "color": "default"
              },
              "plain_text": "Test Database",
              "href": null
            }
          ]
        }
      },
      "url":
          "https://www.notion.so/Test-Database-3a69a00ab816460c804a6a8fb0cf7857"
    }
  ],
  "next_cursor": null,
  "has_more": false
};
