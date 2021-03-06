# Flutter JSON Form

[![Build Status](https://travis-ci.org/sirily11/json-textfrom.svg?branch=master)](https://travis-ci.org/sirily11/json-textfrom)

This is the plugin for flutter using JSON Schema to define the form itself.
It supports:

- Textfield
- Selection field
- forignkey field
- qrcode scanning
- DateTime Field
- custom field icon and action

# Getting start

> Important! The forign key field is using Django Rest Framework with DRF-schema-adapter. All the schema's structures are based on it. You can take a look what the structure is on this [page](https://drf-schema-adapter.readthedocs.io/en/latest/drf_auto_endpoint/metadata/)

## First prepare data

```dart
Map<String, dynamic> itemJSONData = {
  "fields": [
    {
      "label": "ID",
      "readonly": true,
      "extra": {},
      "name": "id",
      "widget": "number",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "Item Name",
      "readonly": false,
      "extra": {"help": "Please Enter your item name", "default": ""},
      "name": "name",
      "widget": "text",
      "required": true,
      "translated": false,
      "validations": {
        "length": {"maximum": 1024}
      }
    }]
```

## put the data into JSONSchemaForm

```dart

SONSchemaForm(
                schema: (snapshot.data['fields'] as List)
                    .map((s) => s as Map<String, dynamic>)
                    .toList(),
                icons: [
                  FieldIcon(schemaName: "name", iconData: Icons.title),
                ],
                actions: [
                  FieldAction(
                      schemaName: "qr_code",
                      actionTypes: ActionTypes.qrScan,
                      actionDone: ActionDone.getInput)
                ],
                onSubmit: (value) {
                  print(value);
                },
              ),

```

As you can see, you can provide actions and icons based on the name property in the schema's data.
