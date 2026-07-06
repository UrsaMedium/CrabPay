import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_bloc.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_event.dart';
import 'package:crabpay/views/dialogs/generic_dialog_text_input.dart'
    show showOnInputDialog;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;

class AddCompleteProductProductView extends StatefulWidget {
  const AddCompleteProductProductView({super.key});

  @override
  State<AddCompleteProductProductView> createState() =>
      _AddCompleteProductProductViewState();
}

class _AddCompleteProductProductViewState
    extends State<AddCompleteProductProductView> {
  String? _description;
  String? _imageUrl;
  String? _productNameUI;
  // String? _currency;
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    context.read<DatabaseBloc>().add(DatabaseEventFetchAllCurrencies());
    super.initState();
  }

  void _refreshOnDescription(String value) {
    setState(() {
      _description = value;
      // _descriptionController = TextEditingController(text: value);
    });
  }

  @override
  void dispose() {
    _currencyController.dispose();
    super.dispose();
  }

  Product? _collectProduct() {
    if (_productNameUI != null && _imageUrl != null && _description != null
    // &&        _currency != null
    ) {
      return Product(
        id: 'id',
        name: _productNameUI!,
        image: _imageUrl!,
        description: _description!,
        currencies: 'rubDefault',
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        !Navigator.of(context).canPop() ? context.go('/ask') : context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (GoRouter.of(context).canPop()) {
                context.pop();
              } else {
                context.go('/ask');
              }
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    _imageUrl = await showOnInputDialog(context, 'Image URL');
                    if (_imageUrl == '') _imageUrl = null;
                  },
                  child: Stack(
                    alignment: .center,
                    children: [
                      Image.asset(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.3,
                        'lib/assets/images/gas-gas-gas.jpg',
                        color: context.appColorScheme.error.withAlpha(50),
                        colorBlendMode: BlendMode.dstIn,
                      ),
                      Text('$_imageUrl'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextButton(
                    onPressed: () async {
                      _productNameUI = await showOnInputDialog(
                        context,
                        'Product Name',
                      );
                      if (_productNameUI == '') {
                        _productNameUI = null;
                      } else {
                        setState(() {});
                      }
                    },
                    child: Text(
                      'Product Name: $_productNameUI',
                      style: TextStyle(
                        backgroundColor: context.appColorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
                  child: BlocBuilder<DatabaseBloc, DatabaseState>(
                    builder: (context, state) {
                      bool enableCurreniesDropdownMenu = false;
                      final List<DropdownMenuEntry<String>> currencies = [];
                      if (state.states == DatabaseStates.currenciesFetched) {
                        enableCurreniesDropdownMenu = true;
                        for (var currencyTable in state.currencies!) {
                          currencies.add(
                            DropdownMenuEntry(
                              value: currencyTable.name,
                              label: 'From ${currencyTable.name}',
                            ),
                          );
                        }
                      } else {
                        enableCurreniesDropdownMenu = false;
                      }
                      return DropdownMenu<String>(
                        enabled: enableCurreniesDropdownMenu,
                        expandedInsets: EdgeInsets.zero,
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: context.appColorScheme.primary,
                              width: 1,
                            ),
                          ),
                        ),
                        // onSelected: (value) => _currency = value,
                        controller: _currencyController,
                        dropdownMenuEntries: currencies,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 4,
                  ),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    onSubmitted: (value) {
                      if (value.trim() == '') {
                        _description = null;
                      }
                      _refreshOnDescription(value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MarkdownBody(
                    selectable: true,
                    data: '$_description',
                    builders: {'latex': LatexElementBuilder()},
                    extensionSet: md.ExtensionSet(
                      [LatexBlockSyntax()],
                      [LatexInlineSyntax()],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: .end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (GoRouter.of(context).canPop()) {
                          context.pop();
                        }
                      },
                      child: Text('Back'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Product? collectedAppProduct = _collectProduct();
                        if (collectedAppProduct != null) {
                          context.read<AdminBloc>().add(
                            AdminEventSubmitsProduct(
                              appProduct: collectedAppProduct,
                            ),
                          );
                          context.push(
                            '/add_complete_product_product_view/add_product_fields_view',
                          );
                        } else {
                          Fluttertoast.showToast(msg: 'Not enough data');
                        }
                      },
                      child: Text('Next'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Product? collectedAppProduct = Product(
                          id: '0',
                          name: 'Mock Name4',
                          image: 'lib/assets/images/gas-gas-gas.jpg',
                          description: 'Mock description',
                          currencies: 'rubDefault',
                        );
                        context.read<AdminBloc>().add(
                          AdminEventSubmitsProduct(
                            appProduct: collectedAppProduct,
                          ),
                        );
                        context.go(
                          '/add_complete_product_product_view/add_product_fields_view',
                        );
                      },
                      child: Text('Mock Data'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
