import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/dialogs/generic_dialog_text_input.dart'
    show showOnInputDialog;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;

class AddCompleteProductView extends StatefulWidget {
  const AddCompleteProductView({super.key});

  @override
  State<AddCompleteProductView> createState() => _AddCompleteProductViewState();
}

class _AddCompleteProductViewState extends State<AddCompleteProductView> {
  String _description = '';
  String? _imageUrl;
  String? _productName;
  TextEditingController _descriptionController = TextEditingController();
  void refreshOndescription(String value) {
    setState(() {
      _description = value;
      // _descriptionController = TextEditingController(text: value);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  _imageUrl = await showOnInputDialog(context, 'Image URL');
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
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () async {
                    _productName = await showOnInputDialog(
                      context,
                      'Product Name',
                    );
                    setState(() {});
                  },
                  child: Text('Product Name: $_productName',style: TextStyle(backgroundColor: context.appColorScheme.onPrimary),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 64.0,
                  vertical: 16,
                ),
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  onSubmitted: (value) {
                    refreshOndescription(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MarkdownBody(
                  selectable: true,
                  data: _description,
                  builders: {'latex': LatexElementBuilder()},
                  extensionSet: md.ExtensionSet(
                    [LatexBlockSyntax()],
                    [LatexInlineSyntax()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static final String _text = r""" 🎮 Crystgin by id and server
🚀 The delivery is automatic and usually takes 3-50 minutes.

❗Specify correct servers, you can check known servers here - https://delivery.crabpay.org/faq/oncehuman-region-servers

❗Any return due to your fault - the fund are returned partially (~20% loss). In case of returns due to our fault the funds are returned fully""";

  //       r"""This is inline latex: $f(x) = \sum_{i=0}^{n} \frac{a_i}{1+x}$

  // This is block level latex:

  // $$
  // c = \pm\sqrt{a^2 + b^2}
  // $$

  // This is inline latex with displayMode: $$f(x) = \sum_{i=0}^{n} \frac{a_i}{1+x}$$

  // The relationship between the height and the side length of an equilateral triangle is:

  // \[ \text{Height} = \frac{\sqrt{3}}{2} \times \text{Side Length} \]

  // \[ \text{X} = \frac{1}{2} \times \text{Y} \times \text{Z} = \frac{1}{2} \times 9 \times \frac{\sqrt{3}}{2} \times 9 = \frac{81\sqrt{3}}{4} \]

  // The basic form of the Taylor series is:

  // \[f(x) = f(a) + f'(a)(x-a) + \frac{f''(a)}{2!}(x-a)^2 + \frac{f'''(a)}{3!}(x-a)^3 + \cdots\]

  // where \(f(x)\) is the function to be expanded, \(a\) is the expansion point, \(f'(a)\), \(f''(a)\), \(f'''(a)\), etc., are the first, second, third, and so on derivatives of the function at point \(a\), and \(n!\) denotes the factorial of \(n\).

  // In particular, when \(a=0\), this expansion is called the Maclaurin series.""";

  final List<String> _fieldsList = ['1', '2', '1', '2', '1', '2'];

  // List<Widget> _fields(BuildContext context) {
  //   List<Widget> result = [];
  //   for (var each in _fieldsList) {
  //     result.add(SliverToBoxAdapter(child: Text(each)));
  //   }
  //   result.add(ElevatedButton.icon(onPressed: () {}, label: Icon(Icons.add)));
  //   return result;
  // }

  Widget _fields(BuildContext context, String field) {
    return Text(field);
  }
}

// Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.75,
//                 ),
//                 child: CustomScrollView(
//                   shrinkWrap: true,
//                   slivers: [
//                     SliverFixedExtentList(
//                       delegate: SliverChildBuilderDelegate((
//                         BuildContext context,
//                         int index,
//                       ) {
//                         return _fields(context, _fieldsList[index]);
//                       }, childCount: _fieldsList.length),
//                       itemExtent: 200,
//                     ),
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                           top: 16,
//                           left: 32,
//                           right: 32,
//                           bottom: 32,
//                         ),
//                         child: Wrap(
//                           alignment: WrapAlignment.center,
//                           children: [
//                             ElevatedButton.icon(
//                               onPressed: () async {
//                                 showModalBottomSheet(
//                                   context: context,
//                                   showDragHandle: true,
//                                   isScrollControlled: true,
//                                   builder: (BuildContext context) {
//                                     return Text('data');
//                                   },
//                                 );
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor:
//                                     context.appColorScheme.onPrimary,
//                                 foregroundColor: context.appColorScheme.primary,
//                                 // minimumSize: Size(double.infinity, 50),
//                               ),
//                               label: Icon(Icons.add),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: context.appColorScheme.primary,
//                   foregroundColor: context.appColorScheme.onPrimary,
//                   minimumSize: Size(double.infinity, 50),
//                 ),
//                 child: Text('Add fieldes'),
//               ),
//             ),
//           ],
//         ),
//       ),
