import 'package:crabpay/core/buySheetShit/widget_factory.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddCompleteProductFieldsView extends StatefulWidget {
  const AddCompleteProductFieldsView({super.key});

  @override
  State<AddCompleteProductFieldsView> createState() =>
      _AddCompleteProductFieldsViewState();
}

class _AddCompleteProductFieldsViewState
    extends State<AddCompleteProductFieldsView> {
  final List<Widget> _fieldsList = [];

  void _updateFieldsList(Widget newField) {
    setState(() {
      _fieldsList.add(newField);
    });
  }

  Widget _fields(BuildContext context, Widget field) {
    return field;
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
                        return _fields(context, _fieldsList[index]);
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
                      onPressed: () {},
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

class AddFieldBottomSheet extends StatefulWidget {
  final Function(Widget) onNewFieldAdding;
  const AddFieldBottomSheet({super.key, required this.onNewFieldAdding});

  @override
  State<AddFieldBottomSheet> createState() => _AddFieldBottomSheetState();
}

class _AddFieldBottomSheetState extends State<AddFieldBottomSheet> {
  String? handler;
  String? propertyName;
  TextEditingController propertyNameController = TextEditingController();
  final List<DropdownMenuItem<String>> _handlersList = [
    DropdownMenuItem(value: 'InputField', child: Text('InputField')),
    DropdownMenuItem(value: 'RadioList', child: Text('RadioList')),
    DropdownMenuItem(value: 'DropdownList', child: Text('DropdownList')),
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 240,
          // MediaQuery.of(context).size.height * 0.3,
        ),
        child: Column(
          mainAxisAlignment: .start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 64,
              ),
              child: TextField(
                controller: propertyNameController,
                onChanged: (value) => propertyName = value.trim(),
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
              // hint: DropdownMenuItem(child: Text('$handler')),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 32,
                top: 12,
              ),
              child: ElevatedButton(
                onPressed: () {
                  widget.onNewFieldAdding(
                    theAppWidgetBuilder(
                      context,
                      propertyName!,
                      handler!,
                      null,
                      null,
                    ),
                  );
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appColorScheme.primary,
                  foregroundColor: context.appColorScheme.onPrimary,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Add Field',
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
