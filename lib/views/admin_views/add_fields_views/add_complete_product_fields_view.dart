import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_fields_model.dart';
import 'package:crabpay/core/buySheetShit/widget_factory.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/admin_views/add_fields_views/field_constructor_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class AddCompleteProductFieldsView extends StatefulWidget {
  const AddCompleteProductFieldsView({super.key});

  @override
  State<AddCompleteProductFieldsView> createState() =>
      _AddCompleteProductFieldsViewState();
}

class _AddCompleteProductFieldsViewState
    extends State<AddCompleteProductFieldsView> {
  final List<AppProductField> _fieldsList = [];
  final Map<AppProductField, Widget> _fieldWidgetsMap = {};
  final Map<String, String> _dataFromFieldsToTest = {};
  final List<String> _fieldNames = [];

  void _updateFieldsList(AppProductField field) {
    if (!_fieldsList.any((element) => element.fieldName == field.fieldName)) {
      setState(() {
        _fieldsList.add(field);
        _fieldNames.add(field.fieldName);
        _fieldWidgetsMap[field] = AField(
          field: field,
          dataBridge: _dataBridgeToTest,
          deleteMe: _deleteField,
        );
      });
    } else {
      Fluttertoast.showToast(
        msg: 'ERROR A field with the same name already exists',
      );
    }
  }

  void _deleteField(AppProductField fieldToDelte) {
    setState(() {
      _fieldsList.remove(fieldToDelte);
      _fieldNames.remove(fieldToDelte.fieldName);
      _fieldWidgetsMap.remove(fieldToDelte);
    });
  }

  void _dataBridgeToTest(String caller, String passedData) {
    setState(() {
      _dataFromFieldsToTest[caller] = passedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              context.pop();
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                ),
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverList.builder(
                      itemCount: _fieldsList.length,
                      itemBuilder: (context, index) {
                        return _fieldWidgetsMap[_fieldsList[index]];
                      },
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 32,
                          right: 32,
                          bottom: 32,
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                showModalBottomSheet(
                                  context: context,
                                  showDragHandle: true,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return AddFieldBottomSheet(
                                      alreadyExistingFields: _fieldNames,
                                      onNewFieldAdding: _updateFieldsList,
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    context.appColorScheme.onPrimary,
                                foregroundColor: context.appColorScheme.primary,
                                // minimumSize: Size(double.infinity, 50),
                              ),
                              label: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: .end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (GoRouter.of(context).canPop()) {
                          context.pop();
                        }
                      },
                      child: Text('Back'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        print(_dataFromFieldsToTest);
                      },
                      child: Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AField extends StatelessWidget {
  final Function(String, String) dataBridge;
  final Function(AppProductField) deleteMe;
  final AppProductField field;
  const AField({
    super.key,
    required this.field,
    required this.dataBridge,
    required this.deleteMe,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      // key: ValueKey(field.fieldName),
      children: [
        theAppWidgetBuilder(
          dataBridge,
          context,
          field.fieldName,
          field.handler,
          null,
          field.expectedData,
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            alignment: .topRight,
            child: IconButton(
              onPressed: () => deleteMe(field),
              icon: Icon(Icons.delete),
            ),
          ),
        ),
      ],
    );
  }
}
