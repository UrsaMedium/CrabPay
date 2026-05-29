import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
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
  String? _productNameAdmin;
  final TextEditingController _descriptionController = TextEditingController();
  void _refreshOnDescription(String value) {
    setState(() {
      _description = value;
      // _descriptionController = TextEditingController(text: value);
    });
  }

  AppProduct? _collectProduct() {
    if (_productNameUI != null && _imageUrl != null && _description != null) {
      return AppProduct(
        id: 'id',
        name: _productNameUI!,
        image: _imageUrl!,
        description: _description!,
      );
    } else {
      return null;
    }
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
                      _imageUrl ?? 'lib/assets/images/gas-gas-gas.jpg',
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
                padding: const EdgeInsets.all(4.0),
                child: TextButton(
                  onPressed: () async {
                    _productNameAdmin = await showOnInputDialog(
                      context,
                      'Admin Product Name',
                    );
                    setState(() {});
                  },
                  child: Text(
                    'Admin Product Name: $_productNameAdmin',
                    style: TextStyle(
                      backgroundColor: context.appColorScheme.onPrimary,
                    ),
                  ),
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
                      AppProduct? collectedAppProduct = _collectProduct();
                      if (collectedAppProduct != null) {
                        context.read<AdminBloc>().add(
                          AdminEventSubmitsProduct(
                            appProduct: collectedAppProduct,
                          ),
                        );
                        context.go(
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
                      AppProduct? collectedAppProduct = AppProduct(
                        id: 'id',
                        name: 'Mock Product',
                        image: 'lib/assets/images/gas-gas-gas.jpg',
                        description: 'Mock description',
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
    );
  }
}
