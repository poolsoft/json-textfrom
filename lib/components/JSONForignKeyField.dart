import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/components/JSONForignKeyEditField.dart';
import 'package:json_schema_form/components/SelectionPage.dart';
import 'package:json_schema_form/models/Action.dart';
import 'package:json_schema_form/models/Icon.dart';
import 'package:json_schema_form/models/NetworkProvider.dart';
import 'package:json_schema_form/models/Schema.dart';
import 'package:json_schema_form/utils.dart';
import 'package:provider/provider.dart';

class JSONForignKeyField extends StatelessWidget {
  final Schema schema;
  final Function onSaved;
  final bool showIcon;
  final bool isOutlined;

  /// List of actions. Each field will only have one action.
  /// If not, the last one will replace the first one.
  final List<FieldAction> actions;

  /// List of icons. Each field will only have one icon.
  /// If not, the last one will replace the first one.
  final List<FieldIcon> icons;

  JSONForignKeyField(
      {@required this.schema,
      this.onSaved,
      this.showIcon = true,
      this.isOutlined = false,
      this.icons,
      this.actions});

  @override
  Widget build(BuildContext context) {
    NetworkProvider networkProvider = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              decoration: isOutlined
                  ? BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).inputDecorationTheme.fillColor)
                  : null,
              child: ListTile(
                trailing: Icon(
                  Icons.expand_more,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text("Select ${schema.label}"),
                subtitle: Text("${schema.choice?.label}"),
                onTap: () async {
                  List<Choice> choices = await networkProvider
                      .getSelections(schema.extra.relatedModel);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) {
                        return SelectionPage(
                          onSelected: (value) {
                            if (this.onSaved != null) {
                              this.onSaved(value);
                            }
                          },
                          title: "Select ${schema.label}",
                          selections: choices,
                          value: schema.value,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: RawMaterialButton(
              elevation: 0,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              fillColor: Colors.blue,
              shape: new CircleBorder(),
              onPressed: () async {
                /// Add new field
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) {
                    return ChangeNotifierProvider(
                      create: (_) => NetworkProvider(
                          networkProvider: networkProvider.networkProvider,
                          url: networkProvider.url),
                      child: JSONForignKeyEditField(
                        isOutlined: isOutlined,
                        title: "Add ${schema.label}",
                        path: schema.extra.relatedModel,
                        isEdit: false,
                        actions: actions,
                        name: schema.name,
                        icons: icons,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          Expanded(
            child: RawMaterialButton(
              elevation: 0,
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              fillColor: schema.choice == null ? Colors.grey : Colors.blue,
              shape: new CircleBorder(),
              onPressed: schema.choice == null
                  ? null
                  : () async {
                      /// Edit current field
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) {
                          return ChangeNotifierProvider<NetworkProvider>(
                            create: (_) => NetworkProvider(
                                networkProvider:
                                    networkProvider.networkProvider,
                                url: networkProvider.url),
                            child: JSONForignKeyEditField(
                              isOutlined: isOutlined,
                              title: "Edit ${schema.label}",
                              path: schema.extra.relatedModel,
                              isEdit: true,
                              id: schema.choice.value,
                              actions: actions,
                              name: schema.name,
                              icons: icons,
                            ),
                          );
                        }),
                      );
                    },
            ),
          ),
          // Expanded(
          //   child: RawMaterialButton(
          //     elevation: 0,
          //     child: Icon(
          //       Icons.remove,
          //       color: Colors.white,
          //     ),
          //     fillColor: Colors.blue,
          //     shape: new CircleBorder(),
          //     onPressed: () {},
          //   ),
          // )
        ],
      ),
    );
  }
}
