import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class AddFieldBottomSheet extends StatefulWidget {
  final Function(ProductField) onNewFieldAdding;
  final List<String> alreadyExistingFields;
  const AddFieldBottomSheet({
    super.key,
    required this.onNewFieldAdding,
    required this.alreadyExistingFields,
  });

  @override
  State<AddFieldBottomSheet> createState() => _AddFieldBottomSheetState();
}

class _AddFieldBottomSheetState extends State<AddFieldBottomSheet> {
  String? handler;
  String? fieldName;
  TextEditingController fieldNameController = TextEditingController();
  final List<DropdownMenuItem<String>> _handlersList = [
    DropdownMenuItem(value: 'InputField', child: Text('InputField')),
    DropdownMenuItem(value: 'RadioList', child: Text('RadioList')),
    DropdownMenuItem(value: 'DropdownList', child: Text('DropdownList')),
  ];
  final List<Widget> _optionsFields = [];
  final Map<OptionField, String> expetedDataBoundToAField = {};

  void _onOptionFieldDelete(OptionField fieldToDelte) {
    setState(() {
      _optionsFields.remove(fieldToDelte);
      expetedDataBoundToAField.remove(fieldToDelte);
    });
  }

  void _optionsFieldNameChange(
    OptionField fieldToChange,
    String expectedDataName,
  ) {
    setState(() {
      expetedDataBoundToAField[fieldToChange] = expectedDataName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
          // MediaQuery.of(context).size.height * 0.3,
        ),
        child: Column(
          mainAxisAlignment: .start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 32,
              ),
              child: TextField(
                controller: fieldNameController,
                onChanged: (value) {
                  if (value != '') {
                    fieldName = value.trim();
                  } else {
                    fieldName = null;
                  }
                },
                decoration: InputDecoration(
                  hint: Text(
                    'Name The Field/Data',
                    style: TextStyle(
                      color: context.appColorScheme.outlineVariant,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                ),
              ),
            ),
            DropdownButton(
              items: _handlersList,
              value: handler,
              onChanged: (value) {
                setState(() {
                  handler = value;
                });
              },
              elevation: 5,
              hint: DropdownMenuItem(
                child: Text(
                  'handler',
                  style: TextStyle(
                    color: context.appColorScheme.outlineVariant,
                  ),
                ),
              ),
            ),
            if (handler == 'DropdownList' || handler == 'RadioList')
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 220),
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverList.builder(
                      itemCount: _optionsFields.length,
                      itemBuilder: (context, index) => _optionsFields[index],
                    ),
                    SliverToBoxAdapter(
                      child: Wrap(
                        alignment: .center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _optionsFields.add(
                                  OptionField(
                                    optionsFieldNameChange:
                                        _optionsFieldNameChange,
                                    onOptionFieldDelete: _onOptionFieldDelete,
                                  ),
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.appColorScheme.onPrimary,
                              foregroundColor: context.appColorScheme.primary,
                            ),
                            label: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 32,
                top: 12,
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (fieldName != null && handler != null) {
                    if (!widget.alreadyExistingFields.any(
                      (element) => element == fieldName,
                    )) {
                      widget.onNewFieldAdding(
                        ProductField(
                          id: 'id',
                          productId: 'productId',
                          order: 0,
                          fieldName: fieldName!,
                          handler: handler!,
                          expectedData: handler! == 'InputField'
                              ? [fieldName!]
                              : expetedDataBoundToAField.values.toList(),
                        ),
                      );
                      context.pop();
                    } else {
                      Fluttertoast.showToast(
                        msg: 'A field with the same name already exists',
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appColorScheme.primary,
                  foregroundColor: context.appColorScheme.onPrimary,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Add The Field',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionField extends StatefulWidget {
  final Function(OptionField) _onOptionFieldDelete;
  final Function(OptionField, String) _optionsFieldNameChange;
  const OptionField({
    super.key,
    required Function(OptionField) onOptionFieldDelete,
    required Function(OptionField, String) optionsFieldNameChange,
  }) : _optionsFieldNameChange = optionsFieldNameChange,
       _onOptionFieldDelete = onOptionFieldDelete;

  @override
  State<OptionField> createState() => _OptionFieldState();
}

class _OptionFieldState extends State<OptionField> {
  TextEditingController expectedDataNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 2,
              bottom: 2,
              left: 32,
              right: 4,
            ),
            child: TextField(
              onChanged: (value) {
                widget._optionsFieldNameChange(widget, value);
              },
              decoration: InputDecoration(
                hint: Text(
                  'Name The Option',
                  style: TextStyle(
                    color: context.appColorScheme.outlineVariant,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 2, right: 16),
          child: IconButton(
            onPressed: () {
              widget._onOptionFieldDelete(widget);
            },
            icon: Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}
