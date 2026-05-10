import 'package:crabpay/core/product_data/product_properties/product_properties_model.dart';
import 'package:crabpay/core/product_data/product_properties/properties_data_outer_circle.dart';

final List<AppProductPropertiers> appProductPropertires = [];

void propertiesDataConsolidation() {
  Map<String, String?>? tempAttrinutesMap;
  Map<String, String>? tempDataHandlerMap;
  for (var element in fetchedAppProductProperties) {
    tempAttrinutesMap = element.attributes as Map<String, String?>?;
    tempDataHandlerMap = element.dataHandler as Map<String, String>?;
    appProductPropertires.add(
      AppProductPropertiers(
        id: element.id,
        productId: element.productId,
        order: element.order,
        propertyName: element.propertyName,
        handler: element.handler,
        attributes: tempAttrinutesMap,
        dataHandler: tempDataHandlerMap
      ),
    );
  }
}

