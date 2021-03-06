// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility that Flutter provides. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_form/JSONForm.dart';
import 'package:json_schema_form/JSONSchemaForm.dart';
import 'package:json_schema_form/components/JSONSelectField.dart';
import 'package:json_schema_form/components/JSONTextFormField.dart';
import 'package:json_schema_form/models/Action.dart';
import 'package:json_schema_form/models/Icon.dart';
import 'package:json_schema_form/models/NetworkProvider.dart';
import 'package:json_schema_form/models/Schema.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'forignkey_edit_field_test.dart';

void main() {
  group("Widget test", () {
    testWidgets('Test selection field', (WidgetTester tester) async {
      Schema schema = Schema(
          isRequired: false, value: "value", label: "hello", name: "hello");

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: JSONSelectField(
              schema: schema,
            ),
          ),
        ),
      );
      expect(find.text("Select hello"), findsOneWidget);
      expect(find.byKey(Key("selection-field")), findsOneWidget);
      final ListTile selectionField =
          tester.widget(find.byKey(Key("selection-field")));
      // since we didn't provide the choices
      // ontap shoule be null
      expect(selectionField.onTap, null);
    });

    testWidgets('Test selection field with value', (WidgetTester tester) async {
      Schema schema = Schema(
        isRequired: false,
        value: "value",
        label: "hello",
        name: "hello",
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: JSONSelectField(
              schema: schema,
            ),
          ),
        ),
      );
      expect(find.text("value"), findsOneWidget);
    });

    testWidgets('Test selection with selection', (WidgetTester tester) async {
      Schema schema = Schema(
        isRequired: false,
        value: "value",
        label: "hello",
        name: "hello",
        extra: Extra(
          choices: [Choice(label: "abc", value: "abc")],
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: JSONSelectField(
              schema: schema,
            ),
          ),
        ),
      );
      expect(find.text("Select hello"), findsOneWidget);
      expect(find.byKey(Key("selection-field")), findsOneWidget);
      final ListTile selectionField =
          tester.widget(find.byKey(Key("selection-field")));
      // since we didn't provide the choices
      // ontap shoule be null
      expect(selectionField.onTap, isNotNull);
    });

    testWidgets('Test text field', (WidgetTester tester) async {
      Schema schema = Schema(
        isRequired: false,
        value: "value",
        label: "hello",
        name: "hello",
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: JSONTextFormField(
              schema: schema,
            ),
          ),
        ),
      );

      expect(find.byKey(Key("textfield")), findsOneWidget);
      expect(find.text("value"), findsOneWidget);
    });

    testWidgets('Test text field with default value',
        (WidgetTester tester) async {
      Schema schema = Schema(
        isRequired: false,
        extra: Extra(defaultValue: "abc"),
        label: "hello",
        name: "hello",
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: JSONTextFormField(
              schema: schema,
            ),
          ),
        ),
      );
      expect(find.byKey(Key("textfield")), findsOneWidget);
      expect(find.text("abc"), findsOneWidget);
    });

    testWidgets('Test text field with default value and value',
        (WidgetTester tester) async {
      Schema schema = Schema(
        isRequired: false,
        value: "cde",
        extra: Extra(defaultValue: "abc"),
        label: "hello",
        name: "hello",
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: JSONTextFormField(
              schema: schema,
            ),
          ),
        ),
      );
      expect(find.byKey(Key("textfield")), findsOneWidget);
      expect(find.text("cde"), findsOneWidget);
    });

    testWidgets('Test if only schema provided', (WidgetTester tester) async {
      List<Map<String, dynamic>> schema = [
        {
          "label": "Name",
          "readonly": false,
          "extra": {},
          "name": "name",
          "widget": "number",
          "required": false,
          "translated": false,
          "validations": {}
        },
        {
          "label": "author",
          "readonly": true,
          "extra": {"related_model": "storage-management/author"},
          "name": "author_name",
          "widget": "foreignkey",
          "required": false,
          "translated": false,
          "validations": {}
        }
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: JSONSchemaForm(
              schema: schema,
            ),
          ),
        ),
      );
      expect(find.byKey(Key("textfield")), findsOneWidget);
    });

    testWidgets('Test icons', (WidgetTester tester) async {
      List<Map<String, dynamic>> schema = [
        {
          "label": "Name",
          "readonly": false,
          "extra": {},
          "name": "name",
          "widget": "number",
          "required": false,
          "translated": false,
          "validations": {}
        },
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: JSONSchemaForm(
              schema: schema,
              icons: [FieldIcon(iconData: Icons.home, schemaName: "name")],
              actions: [
                FieldAction(
                  schemaName: "name",
                  actionTypes: ActionTypes.qrScan,
                )
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets('Test icons while action is for forign key field',
        (WidgetTester tester) async {
      NetworkProvider provider = MockProvider();
      List<Map<String, dynamic>> schema = [
        {
          "label": "Name",
          "readonly": false,
          "extra": {},
          "name": "name",
          "widget": "number",
          "required": false,
          "translated": false,
          "validations": {}
        },
        {
          "label": "author",
          "readonly": false,
          "extra": {"related_model": "storage-management/author"},
          "name": "author_id",
          "widget": "foreignkey",
          "required": false,
          "translated": false,
          "validations": {}
        }
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: JSONSchemaForm(
              schema: schema,
              icons: [
                FieldIcon(
                    iconData: Icons.home,
                    schemaName: "name",
                    schemaFor: "author_id")
              ],
              actions: [
                FieldAction(
                  schemaFor: "author_id",
                  schemaName: "name",
                  actionTypes: ActionTypes.qrScan,
                )
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.home), findsNothing);
      expect(find.byIcon(Icons.camera_alt), findsNothing);
    });

    testWidgets('Test icons while action is for forign key field',
        (WidgetTester tester) async {
      List<Map<String, dynamic>> schema = [
        {
          "label": "Name",
          "readonly": false,
          "extra": {},
          "name": "name",
          "widget": "number",
          "required": false,
          "translated": false,
          "validations": {}
        },
        {
          "label": "author",
          "readonly": false,
          "extra": {"related_model": "storage-management/author"},
          "name": "author_id",
          "widget": "foreignkey",
          "required": false,
          "translated": false,
          "validations": {}
        }
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: JSONSchemaForm(
              schemaName: "author_id",
              schema: schema,
              icons: [
                FieldIcon(
                    iconData: Icons.home,
                    schemaName: "name",
                    schemaFor: "author_id")
              ],
              actions: [
                FieldAction(
                  schemaFor: "author_id",
                  schemaName: "name",
                  actionTypes: ActionTypes.image,
                )
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });
  });
}
