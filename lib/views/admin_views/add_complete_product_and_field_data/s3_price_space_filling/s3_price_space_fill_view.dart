import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_bloc.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_event.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_state.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/s3_price_space_filling/data_and_widgets_preperation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PriceSpaceFillView extends StatefulWidget {
  const PriceSpaceFillView({super.key});

  @override
  State<PriceSpaceFillView> createState() => _PriceSpaceFillViewState();
}

class _PriceSpaceFillViewState extends State<PriceSpaceFillView> {
  DataAndWidgetsPreperation? _dataAndWidgetsPreperation;

  @override
  void initState() {
    context.read<AdminBloc>().add(
      AdminEventEntersPriceImageFilling(context: context),
    );
    super.initState();
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
        child: Column(
          children: [
            BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                _dataAndWidgetsPreperation = state.dataAndWidgetsPreperation;
                if (state.dataAndWidgetsPreperation != null) {
                  if (state.dataAndWidgetsPreperation!.priceImageWidget !=
                      null) {
                    return state.dataAndWidgetsPreperation!.priceImageWidget!;
                  }
                }
                return Text('');
              },
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
                        if (_dataAndWidgetsPreperation != null) {
                          final priceImages = Map<String, double>.from(
                            _dataAndWidgetsPreperation!.priceImage,
                          );
                          context.read<AdminBloc>().add(
                            AdminEventSubmitsPriceImage(
                              priceImage: priceImages,
                              imageField:
                                  _dataAndWidgetsPreperation!.imageField!,
                              fieldsList:
                                  _dataAndWidgetsPreperation!.productFields!,
                            ),
                          );
                          context.push(
                            '/add_complete_product_product_view/add_product_fields_view/price_space_fill_view/data_overview_view',
                          );
                        }
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
